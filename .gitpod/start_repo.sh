#!/bin/bash

set -eu

url=$(gp url | awk -F"//" {'print $2'}) && url+="/" &&
url="https://8080-"$url"/"

cd ${GITPOD_REPO_ROOT}
# Temporarily use an empty config.yaml to get ddev to use defaults
# so we can do composer install. If there's already one there,
# this does no harm.
mkdir -p .ddev && touch .ddev/config.yaml

# If there's a composer.json, do `ddev composer install` (which auto-starts projct)
if [ -f composer.json ]; then
  ddev start
  ddev composer install
fi

# This won't be required in ddev v1.18.2+
printf "host_webserver_port: 8080\nhost_https_port: 2222\nhost_db_port: 3306\nhost_mailhog_port: 8025\nhost_phpmyadmin_port: 8036\nbind_all_interfaces: true\n" >.ddev/config.gitpod.yaml
ddev stop -a
ddev start -y