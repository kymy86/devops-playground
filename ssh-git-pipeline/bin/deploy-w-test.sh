#!/bin/bash

ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null -p41000 $SSH_USER@$HOST << EOF
      cd /usr/src/app
      sudo su
      docker-compose stop
      docker-compose rm -f web
      docker-compose pull web
      docker-compose up -d
EOF