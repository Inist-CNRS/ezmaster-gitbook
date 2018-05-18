#!/bin/bash

# inject config.json parameters to env
# only if not already defined in env
export BUILD_EACH_NBMINUTES=${BUILD_EACH_NBMINUTES:=$(jq -r -M .BUILD_EACH_NBMINUTES /config.json | grep -v null)}
# backup/dump stuff
pull_build.periodically.sh &

exec nginx -g 'daemon off;'
