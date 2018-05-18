#!/bin/bash

git clone --verbose --progress ${GITHUB_URL} /app/src/istex-web-doc

cd /app/src/istex-web-doc
gitbook build
while true
do

    stdout=$(git pull 2>&1)
    if [ "$stdout" == "Already up-to-date." ]
    then
        echo "Documentation déjà à jour"
    else
        echo "mise à jour en cours"
        gitbook build
    fi
    echo "Waiting $BUILD_EACH_NBMINUTES minutes before next vérification."
    sleep ${BUILD_EACH_NBMINUTES}s
done
