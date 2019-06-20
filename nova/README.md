# Nova

A brand new personal money transfering service.

## 事前準備
https://is.gd/H7reTk を参考にStripeの`API KEY`と`API SECRET`を取得する。

```
$ git clone https://github.com/heiseirb/2018-newbies
$ cd  2018-newbies/nova
$ cp .env.sample .env
$ docker-compose up --build



```

## Development
### Stripe test card num

`4242424242424242`


### Run Rails App with Docker

```console
docker-compose up

if update Dockerfile
docker-compose up --build
```

### Run DB migration

```console
docker-compose exec rails bin/rails db:migrate
```

### use rails console

```
$ docker-compose exec rails bin/rails c
```

### use pry (Rails)

```
## already set pry

$ docker ps
$ docker attach rails process id
```
