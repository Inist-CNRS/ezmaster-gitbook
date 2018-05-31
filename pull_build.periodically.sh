#!/bin/bash

echo "UID IS !!!"
echo $USERID

if [ ! -d "/app/src/.git" ];then
    git clone --verbose --progress ${GITHUB_URL} /app/src
fi

npm install
cd /app/src/
gitbook install
npx gitbook build . --gitbook=3.2.3
while true
do
    echo "hey"
    stdout=$(git pull 2>&1)
    if [ "$stdout" == "Already up-to-date." ]
    then
        echo "Doc already up-to-date"
    else
        echo "Ongoing update"
        npx gitbook build . --gitbook=3.2.3
    fi
    echo "Waiting $BUILD_EACH_NBMINUTES minutes before next verification."
    sleep ${BUILD_EACH_NBMINUTES}m
done
