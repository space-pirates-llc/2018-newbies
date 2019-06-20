#!/bin/bash

set -e

eval "$(rbenv init -)"

cd /var/nova/current
export RAILS_ENV=production

if [ -f /var/nova/current/tmp/pids/puma.pid ]; then
  kill -s TERM $(cat /var/nova/current/tmp/pids/puma.pid)
fi
