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

            # Update of build variables
            ezmaster_gitbook=$(jq -r -M ".version" /app/package.json)
            sed -i "s/\(Ezmaster-gitbook version:\) \(.*\)\(<\/p>\)$/\1 $ezmaster_gitbook\3/g" /app/build.html

            gitbook_version=$(gitbook --version | grep "GitBook" | cut -f 3 -d ' ' | head -1)
            sed -i "s/\(GitBook version:\) \(.*\)\(<\/p>\)$/\1 $gitbook_version\3/g" /app/build.html

            date_build_doc=$(date +%d-%m-%Y:%H"h"%M)
            sed -i "s/\(Last doc update date:\) \(.*\)\(<\/p>\)$/\1 $date_build_doc\3/g" /app/build.html
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

            # Update of build variables
            date_build_config=$(date +%d-%m-%Y:%H"h"%M)
            sed -i "s/\(Last config update date:\) \(.*\)\(<\/p>\)$/\1 $date_build_config\3/g" /app/build.html
        fi

        cp -rf /app/build.html /app/src/build.html

        echo "Waiting $BUILD_EACH_NBMINUTES minutes before next verification."
        sleep ${BUILD_EACH_NBMINUTES}m
    done
fi
