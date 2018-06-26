#!/bin/bash

# inject config.json parameters to env
# only if not already defined in env
export GITHUB_URL_MARKDOWN=${GITHUB_URL_MARKDOWN:=$(jq -r -M .GITHUB_URL_MARKDOWN /config.json | grep -v null)}
export GITHUB_URL_CONFIG=${GITHUB_URL_CONFIG:=$(jq -r -M .GITHUB_URL_CONFIG /config.json | grep -v null)}
export BUILD_EACH_NBMINUTES=${BUILD_EACH_NBMINUTES:=$(jq -r -M .BUILD_EACH_NBMINUTES /config.json | grep -v null)}
export SERVER_NAME=${SERVER_NAME:=$(jq -r -M .SERVER_NAME /config.json | grep -v null)}

# Permit to change the server_name in the nginx configuration
if [[ -z "$SERVER_NAME" ]]; then
    sed -i "s/\(server_name\) \($SERVER_NAME\)\(;\)$/\1 localhost\3/g" /etc/nginx/nginx.conf
    sed -i "s/\(server_name_in_redirect\) \([a-zA-Z]\+\\)\(;\)$/\1 off\3/g" /etc/nginx/nginx.conf
else
    sed -i "s/\(server_name\) \(.*\)\(;\)$/\1 ${SERVER_NAME}\3/g" /etc/nginx/nginx.conf
    sed -i "s/\(server_name_in_redirect\) \([a-zA-Z]\+\\)\(;\)$/\1 on\3/g" /etc/nginx/nginx.conf
fi

# pull periodically to check if there are some doc modifications
# if this happens, the watcher take the lead
pull.periodically.sh &

# a watcher that build if they are any changes
while true; do
    if [[ -f /tmp/CloneEffectue ]]; then
        break
    fi
done
watcher.sh &

exec nginx -g 'daemon off;'
