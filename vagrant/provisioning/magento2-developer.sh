#!/bin/bash
set -e

AS_USER="sudo -u ${VAGRANT_USER}"
CUR_DIR=$(pwd)
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)

cd $HOME_DIR/magento2

$AS_USER bin/magento cache:disable full_page
$AS_USER bin/magento cache:disable full_page

$AS_USER tee "dev/profiler-trigger.php" <<"PHPFILE1"
<?php
if (!empty($_COOKIE['MAGENTO_PROFILE'])) {
   $_SERVER['MAGE_PROFILER'] = 'html';
}
PHPFILE1

$AS_USER php -r "\$composer=json_decode(file_get_contents('composer.json'), true); \$composer['autoload-dev'] += ['files' => ['dev/profiler-trigger.php']]; file_put_contents('composer.json', json_encode(\$composer, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));"
$AS_USER composer dump-autoload

cd $CUR_DIR
