#!/bin/bash

set -e

echo "Changing user id"
IS_HHVM_RUNNING=$(service hhvm status | grep "stop" > /dev/null && echo "" || echo "1")
service nginx stop
service ${VAGRANT_FPM_SERVICE} stop
[ $IS_HHVM_RUNNING ] && service hhvm stop
usermod -u ${VAGRANT_UID} ${VAGRANT_USER}
service nginx start
service ${VAGRANT_FPM_SERVICE} start
[ $IS_HHVM_RUNNING ] && service hhvm start
true # Return true at the end of the stack
