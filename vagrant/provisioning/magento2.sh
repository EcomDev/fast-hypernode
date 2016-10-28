#!/bin/bash

set -e

AS_USER="sudo -u ${VAGRANT_USER}"
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)
MAGENTO_DIR=${VAGRANT_PROJECT_DIR:-magento2}

$AS_USER touch ${HOME_DIR}/nginx/magento2.flag

[ -d ${HOME_DIR}/${MAGENTO_DIR} ] || $AS_USER mkdir ${HOME_DIR}/${MAGENTO_DIR}
[ -d ${HOME_DIR}/public ] || $AS_USER mkdir ${HOME_DIR}/public
