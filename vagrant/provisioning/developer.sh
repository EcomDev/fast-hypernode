#!/bin/bash

set -e
AS_USER="sudo -u ${VAGRANT_USER}"
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)

$AS_USER tee ${HOME_DIR}/nginx/server.devmode <<"CONFIG"
set $developermode "1";
CONFIG
