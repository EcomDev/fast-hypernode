#!/bin/bash

set -e

AS_USER="sudo -u ${VAGRANT_USER}"
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)

$AS_USER touch ${HOME_DIR}/nginx/magento2.flag

[ -d ${HOME_DIR}/magento2 ] || $AS_USER mkdir ${HOME_DIR}/magento2
[ -d ${HOME_DIR}/public ] || $AS_USER mkdir ${HOME_DIR}/public
