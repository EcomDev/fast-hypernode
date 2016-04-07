#!/bin/bash

set -e

echo "Changing user id"
service nginx stop
service php5-fpm stop
service hhvm stop
usermod -u ${VAGRANT_UID} ${VAGRANT_USER}
service nginx start
service php5-fpm start
service hhvm start
