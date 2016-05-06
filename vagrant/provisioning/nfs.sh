#!/bin/bash

set -e

echo "Changing user id"
service nginx stop
service ${VAGRANT_FPM_SERVICE} stop
service hhvm stop
usermod -u ${VAGRANT_UID} ${VAGRANT_USER}
service nginx start
service ${VAGRANT_FPM_SERVICE} start
service hhvm start
