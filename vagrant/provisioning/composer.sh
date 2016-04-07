#!/bin/bash

set -e
[ -f "/usr/local/bin/composer" ] || php -r "readfile('https://getcomposer.org/installer');" \
    | php -- --install-dir=/usr/local/bin --filename=composer
