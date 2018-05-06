#!/bin/bash

set -e

sleep 2

apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
