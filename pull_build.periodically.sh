#!/bin/bash

git clone https://github.com/istex/istex-web-doc.git /app/src
cd /app/src/istex-web-doc
gitbook build
while true
do

    stdout=$(git pull)
    if [ "$stdout" == "Already up-to-date." ]
    then
        echo "Documentation déjà à jour"
    else
        echo "mise à jour"
        gitbook build
    fi
    echo "Waiting $BUILD_EACH_NBMINUTES minutes before next pull."
    sleep ${BUILD_EACH_NBMINUTES}s
done
