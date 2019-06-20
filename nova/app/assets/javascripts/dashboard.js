document.addEventListener('DOMContentLoaded', function() {
  var html = document.getElementsByTagName('html')[0];
  if(html.className != 'dashboard-controller show-action') {
    return;
  }

  var creditCardForm = document.getElementById('credit-card');
  var stripe = Stripe(creditCardForm.getAttribute('api-key'));
  var elements = stripe.elements();
  var creditCard = elements.create('card');
  var hasCreditCard = creditCardForm.getAttribute('data-found') === 'true';

  var api = {
    query: function(params) {
      var queryString = [];
      for(var key in params) {
        if(params.hasOwnProperty(key)) {
          queryString.push(encodeURIComponent(key) + "=" + encodeURIComponent(params[key]))
        }
      }
      return queryString.join('&');
    },
    get: function(path, params) {
      if(params) {
        path = path + '?' + api.query(params);
      }
      return api.request('get', path);
    },
    post: function(path, params) {
      return api.request('post', path, params);
    },
    put: function(path, params) {
      return api.request('put', path, params);
    },
    delete: function(path, params) {
      return api.request('delete', path, params);
    },
    handleError: function(response) {
      if (!response.ok) {
        return response.json().then(function(err) {
          throw err.errors;
        })
      }
      return response
    },
    request: function(method, path, params) {
      var opts = {
        method: method.toUpperCase(),
        credentials: 'same-origin',
        headers: {},
      };

      if(method != 'get' && params) {
        opts.body = JSON.stringify(params);
        opts.headers['Content-Type'] = 'application/json';
      };

      return fetch(path, opts).then(api.handleError).then(function(response) {
        return response.json();
      });
    },
  };

  var errorsStore = {
    state: {
      errors: []
    },
    setErrorsAction (newErrors) {
      this.state.errors.splice(0, this.state.errors.length)

      var self = this;

      if (Array.isArray(newErrors))  {
        Array.prototype.push.apply(self.state.errors, newErrors)
      } else {
        // { "user": ["error A"], "eamil": ["error B"] } }
        // のように返ってくるエラーレスポンスから、
        // ["user error A", "email error B"] のような配列を作成してself.state.errorsに詰める
        Object.keys(newErrors).forEach(function(key) {
          mapedErrors = newErrors[key].map(error => {
            return key + " " + error;
          });
          Array.prototype.push.apply(self.state.errors, mapedErrors);
        });
      }
    },
    clearErrorsAction () {
      this.state.errors.splice(0, this.state.errors.length)
    }
  };

  Vue.component('error-box', {
    data: function () {
      return {
        errorsStoreState: errorsStore.state
      };
    },
    methods: {
      hide: function() {
        errorsStore.clearErrorsAction();
      },
    },
    template: `
      <article class="message is-danger" v-if="errorsStoreState.errors.length != 0">
        <div class="message-header">
          <p>Error</p>
          <button class="delete" aria-label="delete" @click="hide"></button>
        </div>
        <div class="message-body">
          <ul>
            <li v-for="error in errorsStoreState.errors">{{ error }}</li>
          </ul>
        </div>
      </article>`
  });

  var dashboard = new Vue({
    el: '#dashboard',
    data: {
      currentTab: 'remits',
      amount: undefined,
      charges: [],
      charge_histories: [],
      recvRemits: [],
      sentRemits: [],
      hasCreditCard: hasCreditCard,
      isRegisteringCreditCard: false,
      isActiveNewRemitForm: false,
      isCharging: false,
      target: "",
      user: {
        email: "",
        nickname: "",
      },
      newRemitRequest: {
        emails: [],
        amount: 0,
      },
    },

    beforeMount: function() {
      var self = this;
      api.get('/api/user').then(function(json) {
        self.user = json;
      });

      api.get('/api/charges').then(function(json) {
        self.charges = self.prettifyChargesResponse(json.charges);
      });

      api.get('/api/charge_histories').then(function(json) {
        self.charge_histories = self.prettifyChargesResponse(json.charges);
      });

      api.get('/api/balance').then(function(json) {
        self.amount = json.amount
      })

      api.get('/api/remit_requests', { status: 'outstanding' }).
        then(function(json) {
          self.recvRemits = json;
        });

      setInterval(function() {
        api.get('/api/remit_requests', { status: 'outstanding' }).
          then(function(json) {
            self.recvRemits = json;
          });
      }, 15000);
    },
    mounted: function() {
      var form = document.getElementById('credit-card');
      if(form){ creditCard.mount(form); }
    },
    methods: {
      prettifyChargesResponse: function(charges) {
        for (var i = 0; i < charges.length; i++){
          var strDateTime = charges[i]['created_at'];
          var myDate = new Date(strDateTime);
          charges[i]['created_at'] = myDate.toLocaleString();
        }
        return charges;
      },
      showError: function(errors) {
        errorsStore.setErrorsAction(errors)
      },
      removeError: function(errors) {
        errorsStore.clearErrorsAction(errors)
      },
      charge: function(amount, event) {
        if(event) { event.preventDefault(); }

        this.isCharging = true;

        var self = this;
        api.post('/api/charges', { amount: amount }).
          then(function(json) {
            var strDateTime = json['created_at'];
            json['created_at'] = new Date(strDateTime).toLocaleString();
            self.charges.unshift(json);
          }).
          finally(function(){

            // Charge完了までポーリングを開始する
            var timer = setInterval(function() {
              api.get('/api/charges').then(function(json) {
                self.charges = self.prettifyChargesResponse(json.charges);

                // Chargeがなくなったことは、chargeが完了してcharge historyが作られたことを意味する
                if (self.charges.length == 0) {
                  clearInterval(timer);
                  api.get('/api/charge_histories').then(function(json) {
                    self.charge_histories = self.prettifyChargesResponse(json.charges);
                  })
                  api.get('/api/balance').then(function(json) {
                    self.amount = json.amount
                    self.isCharging = false;
                  })
                }
              });
            }, 3000);
          }).
          catch(function(errors) {
            self.showError(errors);
          });
      },
      registerCreditCard: function(event) {
        if(event) { event.preventDefault(); }

        this.isRegisteringCreditCard = true;

        var self = this;
        stripe.createToken(creditCard).
          then(function(result) {
            return api.post('/api/credit_card', { credit_card: { source: result.token.id }});
          }).
          then(function() {
            self.hasCreditCard = true;
          }).
          finally(function() {
            self.isRegisteringCreditCard = false;
          });
      },
      addTarget: function(event) {
        if(event) { event.preventDefault(); }

        if(!this.newRemitRequest.emails.includes(this.target)) {
          this.newRemitRequest.emails.push(this.target);
        }
      },
      removeTarget: function(email, event) {
        if(event) { event.preventDefault(); }

        this.newRemitRequest.emails = this.newRemitRequest.emails.filter(function(e) {
          return e != email;
        });
      },
      sendRemitRequest: function(event) {
        if(event) { event.preventDefault(); }

        var self = this;
        api.post('/api/remit_requests', this.newRemitRequest).
          then(function() {
            self.newRemitRequest = {
              emails: [],
              amount: 0,
            };
            self.target = '';
            self.isActiveNewRemitForm = false;
          }).
          catch(function(errors) {
            self.showError(errors);
          });
      },
      accept: function(id, event) {
        if(event) { event.preventDefault(); }

        var self = this;
        api.post('/api/remit_requests/' + id + '/accept').
          then(function() {
            self.recvRemits = self.recvRemits.filter(function(r) {
              if(r.id != id) {
                return true
              } else {
                self.amount -= r.amount;
                return false
              }
            });
          }).
          catch(function(errors) {
            self.showError(errors);
          });
      },
      reject: function(id, event) {
        if(event) { event.preventDefault(); }

        var self = this;
        api.post('/api/remit_requests/' + id + '/reject').
          then(function() {
            self.recvRemits = self.recvRemits.filter(function(r) {
              return r.id != id;
            });
          }).
          catch(function(errors) {
            self.showError(errors);
          });
      },
      updateUser: function(event) {
        if(event) { event.preventDefault(); }
      },
    }
  });
});
