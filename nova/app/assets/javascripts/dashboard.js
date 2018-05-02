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

      return fetch(path, opts).then(function(response) {
        return response.json();
      });
    },
  };

  var dashboard = new Vue({
    el: '#dashboard',
    data: {
      currentTab: 'remits',
      amount: 0,
      charges: [],
      recvRemits: [],
      sentRemits: [],
      hasCreditCard: hasCreditCard,
      isActiveNewRemitForm: false,
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
        self.amount = json.amount;
        self.charges = json.charges;
      });

      api.get('/api/remit_requests', { status: 'outstanding' }).
        then(function(json) {
          self.recvRemits = json;
        });

      setInterval(function() {
        api.get('/api/remit_requests', { status: 'outstanding' }).
          then(function(json) {
            self.recvRemits = json;
          });
      }, 5000);
    },
    mounted: function() {
      var form = document.getElementById('credit-card');
      if(form){ creditCard.mount(form); }
    },
    methods: {
      charge: function(amount, event) {
        if(event) { event.preventDefault(); }

        var self = this;
        api.post('/api/charges', { amount: amount }).
          then(function(json) {
            self.amount += amount;
            self.charges.unshift(json);
          }).
          catch(function(err) {
            console.error(err);
          });
      },
      registerCreditCard: function(event) {
        if(event) { event.preventDefault(); }

        var self = this;
        stripe.createToken(creditCard).
          then(function(result) {
            return api.post('/api/credit_card', { credit_card: { source: result.token.id }});
          }).
          then(function() {
            self.hasCreditCard = true;
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
          });
      },
      updateUser: function(event) {
        if(event) { event.preventDefault(); }

        var self = this;
        api.put('/api/user', { user: this.user }).
          then(function(json) {
            self.user = json;
          });
      },
    }
  });
});
