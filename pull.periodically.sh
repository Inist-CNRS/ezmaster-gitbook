#!/bin/bash

git clone https://github.com/git-hook/post-clone /tmp/post-clone

if [[ $GITBOOK_DEBUG -eq 1 ]]
then
    if [[ ! -d "/app/doc/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL_MARKDOWN} /app/doc
    else
        cd /app/doc
        git pull
    fi
    if [[ ! -d "/app/config/.git" ]];then
        git clone --verbose --progress --template=/tmp/post-clone ${GITHUB_URL_CONFIG} /app/config
        touch /tmp/CloneDebugEffectue
    else
        cd /app/config
        git pull
    fi

    echo "######################################################"
    echo "#  DEBUG MODE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!   #"
    echo "######################################################"
    chown -R $USERID:$GROUPID /app

else

    # if [[ ! -d "/app/src/.git" ]];then
    #     git clone --verbose --progress ${GITHUB_URL} /app/src
    # else
    #     rm -rf /app/src/
    #     git clone --verbose --progress ${GITHUB_URL} /app/src
    # fi
    if [[ ! -d "/app/doc/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL_MARKDOWN} /app/doc
    else
        rm -rf /app/doc
        git clone --verbose --progress ${GITHUB_URL_MARKDOWN} /app/doc
    fi
    if [[ ! -d "/app/config/.git" ]];then
        git clone --verbose --progress ${GITHUB_URL_CONFIG} /app/config
        touch /tmp/CloneDebugEffectue
    else
        rm -rf /app/config
        git clone --verbose --progress ${GITHUB_URL_CONFIG} /app/config
        touch /tmp/CloneDebugEffectue
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
