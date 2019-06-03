#!/bin/bash

SRC_DIR=/usr/src/dist

DESTINATION_PATH=public_html/
USER_KEY_PATH=~/.ssh/id_rsa
PORT=22
IGNORE_FILE=.deployignore

#create dist folder
rm -rf $SRC_DIR
mkdir -p $SRC_DIR

# copy only the folders/files neeeded
if ! [ -f "$IGNORE_FILE" ]
then
    echo ".deployignore file doesn't exist"
    exit 1
fi

for f in ./*; do
    if ! grep -Fxq "${f##*/}" $IGNORE_FILE ;
    then
        cp -R "$f" $SRC_DIR
    fi
done

cd $SRC_DIR

#pack the deployment bundle
tar -czf dist.tar.gz ./*

#copy the deployment bundle
scp -i $USER_KEY_PATH -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -P$PORT dist.tar.gz $SSH_USER@$HOST:$DESTINATION_PATH

#unpack the deployment bundle and deploy the new files
ssh -i $USER_KEY_PATH -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -p$PORT $SSH_USER@$HOST << EOF
    cd $DESTINATION_PATH
    tar -xvf dist.tar.gz --overwrite 
    rm -rf dist.tar.gz
    chown -R $SSH_USER:$SSH_USER .
    find . -type f -exec chmod 644 {} +
    find . -type d -exec chmod 755 {} +
EOF


