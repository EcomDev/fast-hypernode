#!/bin/bash
set -e

truncate -s 0 /var/mail/app

AS_USER="sudo -u ${VAGRANT_USER}"
HOME_DIR=$(getent passwd ${VAGRANT_USER} | cut -d ':' -f6)
$AS_USER mkdir -p "${HOME_DIR}/.ssh"
$AS_USER touch "${HOME_DIR}/.ssh/authorized_keys"
chmod 700 "${HOME_DIR}/.ssh"
chmod 600 "${HOME_DIR}/.ssh/authorized_keys"

if ssh-add -L >/dev/null 2>/dev/null; then
    ssh-add -L >> ${HOME_DIR}/.ssh/authorized_keys;
fi

cat << EOF >> ${HOME_DIR}/.ssh/authorized_keys
EOF

rm -f "/var/lib/varnish/`hostname`"
ln -s /var/lib/varnish/xxxxx-dummytag-vagrant.nodes.hypernode.io/ "/var/lib/varnish/`hostname`"

rm -rf /etc/cron.d/hypernode-fpm-monitor

# Copy default nginx configs to synced nginx directory if the files don't exist
if [ -d /etc/hypernode/defaults/nginx/ ]; then
    su ${VAGRANT_USER} -c 'find /etc/hypernode/defaults/nginx -type f | xargs -I {} cp -n {} /data/web/nginx/'
fi

# Update magerun to the latest version
/usr/local/bin/n98-magerun -q self-update || true
/usr/local/bin/n98-magerun2 -q self-update || true

usermod -a -G sudo app

# for xenial switch to PHP7.1
command -v hypernode-switch-php >/dev/null 2>&1 && hypernode-switch-php 7.1 2>&1


