#!/bin/bash

# inject config.json parameters to env
# only if not already defined in env
export GITHUB_URL=${GITHUB_URL:=$(jq -r -M .GITHUB_URL /config.json | grep -v null)}
export BUILD_EACH_NBMINUTES=${BUILD_EACH_NBMINUTES:=$(jq -r -M .BUILD_EACH_NBMINUTES /config.json | grep -v null)}
export SERVER_NAME=${SERVER_NAME:=$(jq -r -M .SERVER_NAME /config.json | grep -v null)}

# Permit to change the server_name in the nginx configuration
sed -i "s/\(server_name\) \(.*\)\(;\)$/\1 ${SERVER_NAME}\3/g" nginx.conf

# pull periodically to check if there are some doc modifications
# if this happens, the watcher take the lead
pull.periodically.sh &

# a watcher that build if they are any changes
watcher.sh &

exec nginx -g 'daemon off;'
