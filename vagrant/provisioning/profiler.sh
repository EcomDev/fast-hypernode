#!/bin/bash

set -e

AS_USER="sudo -u ${VAGRANT_USER}"
CUR_DIR=$(pwd)
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)

apt-get install ${VAGRNAT_PHP_PACKAGE_PREFIX}-dev graphviz build-essential -y -q

[ -d $HOME_DIR/tideways-profiler ] || $AS_USER mkdir $HOME_DIR/tideways-profiler
[ -d $HOME_DIR/tideways-profiler/.git ] || $AS_USER git clone https://github.com/tideways/php-profiler-extension.git $HOME_DIR/tideways-profiler

cd $HOME_DIR/tideways-profiler
$AS_USER phpize
$AS_USER ./configure
$AS_USER make
make install

cd $HOME_DIR
$AS_USER wget -O xhprof.tgz https://www.dropbox.com/s/z7mya52qve24cyj/xhprof.tgz?dl=1
$AS_USER tar xzf xhprof.tgz
$AS_USER rm xhprof.tgz
$AS_USER tee "$HOME_DIR/xhprof/prepend.php" <<"PHPFILE1"
<?php
if (!empty($_SERVER['PHP_PROFILE']) || !empty($_COOKIE['PHP_PROFILE'])) {
   tideways_enable(TIDEWAYS_FLAGS_NO_SPANS);
   register_shutdown_function(function () {
     $profilerData = tideways_disable();
     $appNamespace = isset($_SERVER['APP_NAMESPACE']) ? $_SERVER['APP_NAMESPACE'] : 'magento';
     require_once __DIR__ . '/xhprof_lib/utils/xhprof_lib.php';
     require_once __DIR__ . '/xhprof_lib/utils/xhprof_runs.php';
     $xhprofRuns = new XHProfRuns_Default();
     $xhprofRuns->save_run($profilerData, $appNamespace);
  });
}
PHPFILE1

tee ${VAGRNAT_PHP_ETC_DIR}/fpm/conf.d/tideways.ini <<PHPINI
extension=tideways.so
auto_prepend_file=$HOME_DIR/xhprof/prepend.php
tideways.auto_prepend_library=0
PHPINI

cp ${VAGRNAT_PHP_ETC_DIR}/fpm/conf.d/tideways.ini ${VAGRNAT_PHP_ETC_DIR}/cli/conf.d/tideways.ini

if [ ! -L /data/web/staging ]
then
   ln -sf $HOME_DIR/xhprof/xhprof_html $HOME_DIR/staging
fi

cd $CUR_DIR
