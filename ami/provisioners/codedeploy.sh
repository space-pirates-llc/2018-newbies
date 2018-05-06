#!/bin/bash

set -e

sleep 2

apt-get install -y ruby wget

cd /tmp
wget https://aws-codedeploy-ap-northeast-1.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
rm ./install

service codedeploy-agent start
service codedeploy-agent status
