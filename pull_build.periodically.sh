#!/bin/bash

if [ ! -d "/app/src/.git" ];then
    git clone --verbose --progress ${GITHUB_URL} /app/src
fi

if [ $GITBOOK_DEBUG -eq 1 ]
then
    cd /app/src/
    gitbook install
    gitbook build . --gitbook=3.2.3
    chown -R $USERID:$GROUPID /app
    cd ..
    npm run watch
else
    cd /app/src/
    gitbook install
    gitbook build . --gitbook=3.2.3
    while true
    do
        stdout=$(git pull 2>&1)
        if [ "$stdout" == "Already up-to-date." ]
        then
            echo "Doc already up-to-date"
        else
            echo "Ongoing update"
            gitbook build . --gitbook=3.2.3
        fi

        echo "Waiting $BUILD_EACH_NBMINUTES minutes before next verification."
        sleep ${BUILD_EACH_NBMINUTES}m
    done
fi
