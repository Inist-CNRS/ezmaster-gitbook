#!/bin/bash

git clone --verbose --progress ${GITHUB_URL} /app/src
cd /app/src/
gitbook build . --gitbook=3.2.3
while true
do

    stdout=$(git pull 2>&1)
    if [ "$stdout" == "Already up-to-date." ]
    then
        echo "Doc already up-to-date"
    else
        echo "ongoing update"
        gitbook build
    fi
    echo "Waiting $BUILD_EACH_NBMINUTES minutes before next verification."
    sleep ${BUILD_EACH_NBMINUTES}m
done
