#!/bin/bash

set -e

eval "$(rbenv init -)"

cd /var/nova/current
export RAILS_ENV=production

bundle exec puma -d -e production -C config/puma.rb
bundle exec sidekiq -d -e production
