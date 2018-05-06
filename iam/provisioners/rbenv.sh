#!/bin/bash

set -e

sleep 2

apt-get install -y build-essential git rbenv libssl-dev libreadline-dev zlib1g-dev libyaml-dev nodejs

su - ubuntu -c 'mkdir -p ~/.rbenv'
su - ubuntu -c 'git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build'

su - ubuntu -c 'touch /home/ubuntu/.bash_profile'
cat <<'EOS' >> /home/ubuntu/.bash_profile
export RBENV_ROOT=$HOME/.rbenv
eval "$(rbenv init -)"
EOS

su - ubuntu -c 'bash -l -c "CONFIGURE_OPTS=--disable-install-rdoc rbenv install 2.5.1"'
su - ubuntu -c 'bash -l -c "rbenv global 2.5.1"'
