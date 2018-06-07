#!/bin/bash

# inject config.json parameters to env
# only if not already defined in env
export GITHUB_URL=${GITHUB_URL:=$(jq -r -M .GITHUB_URL /config.json | grep -v null)}
export BUILD_EACH_NBMINUTES=${BUILD_EACH_NBMINUTES:=$(jq -r -M .BUILD_EACH_NBMINUTES /config.json | grep -v null)}

# data recovery
pull.periodically.sh &

# watcher
watcher.sh &

exec nginx -g 'daemon off;'
