#!/bin/bash

if [[ $GITBOOK_DEBUG -eq 1 ]]
then
    if [[ ! -d "/app/doc/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL_MARKDOWN} /app/doc
    else
        cd /app/doc
        git pull
    fi
    if [[ ! -d "/app/config/.git" ]];then
        if [[ -z "${GITHUB_URL_CONFIG}" ]]; then
		    mkdir /app/config
	    else
	        git clone --verbose --progress ${GITHUB_URL_CONFIG} /app/config
	    fi
        touch /tmp/CloneDone
    else
        # Permit to know when the clone is finished to start the watcher
	    touch /tmp/CloneDone
    fi

    echo "######################################################"
    echo "#  DEBUG MODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   #"
    echo "######################################################"
    chown -R $USERID:$GROUPID /app

else

    rm -rf /app/src/*
    if [[ ! -d "/app/doc/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL_MARKDOWN} /app/doc
    else
        rm -rf /app/doc
        git clone --verbose --progress ${GITHUB_URL_MARKDOWN} /app/doc
    fi
    if [[ ! -d "/app/config/.git" ]];then
        if [[ -z "${GITHUB_URL_CONFIG}" ]]; then
            echo "Warning: maybe you don't have a config for your doc !"
		    mkdir /app/config
	    else
	        git clone --verbose --progress ${GITHUB_URL_CONFIG} /app/config
	    fi
        touch /tmp/CloneDone
    else
        rm -rf /app/config
	    if [[ -z "${GITHUB_URL_CONFIG}" ]]; then
		    mkdir /app/config
	    else
	        git clone --verbose --progress ${GITHUB_URL_CONFIG} /app/config
	    fi
	    touch /tmp/CloneDone
    fi

    echo "######################################################"
    echo "#  PROD MODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!    #"
    echo "######################################################"

    while true
    do
        # Partie doc
        cd /app/doc/
        git reset --hard HEAD
        stdoutDoc=$(git pull 2>&1)
        if [ "$stdoutDoc" == "Already up-to-date." ]
        then
            echo "Doc already up-to-date"
        else
            echo "Ongoing update"
        fi

        # Partie config
        cd /app/config/
        git reset --hard HEAD
        stdoutConfig=$(git pull 2>&1)
        if [ "$stdoutConfig" == "Already up-to-date." ]
        then
            echo "Config already up-to-date"
        else
            echo "Ongoing update"
        fi

        echo "Waiting $BUILD_EACH_NBMINUTES minutes before next verification."
        sleep ${BUILD_EACH_NBMINUTES}m
    done
fi
