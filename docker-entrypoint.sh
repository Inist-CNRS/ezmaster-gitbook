#!/bin/bash

# inject config.json parameters to env
# only if not already defined in env
export GITHUB_URL=${GITHUB_URL:=$(jq -r -M .GITHUB_URL /config.json | grep -v null)}
export BUILD_EACH_NBMINUTES=${BUILD_EACH_NBMINUTES:=$(jq -r -M .BUILD_EACH_NBMINUTES /config.json | grep -v null)}

# pull periodically to check if there are some doc modifications
# if this happens, the watcher take the lead
pull.periodically.sh &

# a watcher that build if they are any changes
watcher.sh &

exec nginx -g 'daemon off;'
