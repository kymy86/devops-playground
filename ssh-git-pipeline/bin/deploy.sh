#!/bin/bash

ssh -vvv -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -p41000 $SSH_USER@PROD_HOST << EOF
      cd /usr/src/app
      sudo su
      git pull 
      pm2 reload app --update-env 
EOF