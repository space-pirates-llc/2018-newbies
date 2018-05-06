#!/bin/bash

set -e

sleep 2

if ! apt-key list | grep D401AB61 > /dev/null; then
  apt-key adv --keyserver keyserver.ubuntu.com --recv D401AB61
fi

if [ ! -f /etc/apt/sources.list.d/itamae.list ]; then
  echo "deb https://dl.bintray.com/itamae/itamae xenial contrib" > /etc/apt/sources.list.d/itamae.list
  apt-get update
fi

if ! type itamae > /dev/null 2>&1; then
  DEBIAN_FRONTEND=noninteractive apt-get install -y itamae
fi
