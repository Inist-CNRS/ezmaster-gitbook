#!/bin/bash

if [[ $GITBOOK_DEBUG -eq 1 ]]
then
    if [[ ! -d "/app/src/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL} /app/src
    fi

    echo "######################################################"
    echo "#  DEBUG MODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   #"
    echo "######################################################"
    chown -R $USERID:$GROUPID /app
else

    if [[ ! -d "/app/src/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL} /app/src
    else
        rm -rf /app/src/
        git clone --verbose --progress ${GITHUB_URL} /app/src
    fi
    echo "######################################################"
    echo "#  PROD MODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    #"
    echo "######################################################"

    cd /app/src/
    while true
    do
        git reset --hard HEAD
        stdout=$(git pull 2>&1)
        if [ "$stdout" == "Already up-to-date." ]
        then
            echo "Doc already up-to-date"
        else
            echo "Ongoing update"
        fi
        echo "Waiting $BUILD_EACH_NBMINUTES minutes before next verification."
        sleep ${BUILD_EACH_NBMINUTES}m
    done
fi
