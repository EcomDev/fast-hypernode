#!/bin/bash

echo "Welcome to Hypernode Vagrant Box!"
echo "You can login now with in order to use your box:"
echo "\$ ssh ${VAGRANT_USER}@${VAGRANT_HOSTNAME} -A"
echo "To access database, you can use the following credentials in your app:"
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)
MYSQLPASSWORD=$(awk -F "=" '/password/ {print $2}' ${HOME_DIR}/.my.cnf | sed -e 's/^[ \t]*//')

echo "Username: ${VAGRANT_USER}"
echo "Password: $MYSQLPASSWORD"