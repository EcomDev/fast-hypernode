#!/bin/bash

set -e

AS_USER="sudo -u ${VAGRANT_USER}"
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)
MAGENTO_DIR=${VAGRANT_PROJECT_DIR:-magento2}

cd ${HOME_DIR}/${MAGENTO_DIR}

MYSQLPASSWORD=$(awk -F "=" '/password/ {print $2}' ${HOME_DIR}/.my.cnf | sed -e 's/^[ \t]*//')
[ -f ${HOME_DIR}/${MAGENTO_DIR}/app/etc/env.php ] || mysql -u app -p${MYSQLPASSWORD} -e "create database magento2"

echo "Downloading Magento 2..."

[ -d ${HOME_DIR}/${MAGENTO_DIR}/bin ] || $AS_USER wget -qO- https://magento.mirror.hypernode.com/releases/magento2-latest.tar.gz | $AS_USER tar xfz -
$AS_USER chmod 755 bin/magento

echo "Installing ..."

[ -f ${HOME_DIR}/${MAGENTO_DIR}/app/etc/env.php ] || $AS_USER bin/magento setup:install --db-host=localhost --db-name=magento2 --db-user=app --db-password=${MYSQLPASSWORD} --admin-firstname=Admin --admin-lastname=user --admin-user=admin --admin-password=Password123 --admin-email=ivan@ecomdev.org --base-url=http://${VAGRANT_HOSTNAME}/ --language=en_US --timezone=Europe/Amsterdam --currency=EUR --use-rewrites=1
$AS_USER ln -fs ../${MAGENTO_DIR}/pub/* ../public
$AS_USER bin/magento setup:static-content:deploy

echo "Static content deployed ..."
