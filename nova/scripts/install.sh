#!/bin/bash

set -e

eval "$(rbenv init -)"

cd /var/nova/current
export RAILS_ENV=production

sudo itamae local recipe.rb

gem install --no-document bundler
rbenv rehash

bundle install -j 4 --deployment --path=vendor/bundle --without development test
bundle exec rake db:create db:migrate
bundle exec rake assets:precompile
bundle exec rake assets:clean[5]
