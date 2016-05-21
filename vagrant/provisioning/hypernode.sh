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

usermod -a -G admin app

# Remove mysql user from cgroup limitation, as hardcoded ones during deployment of hypernode box swap all stuff out
tee /etc/cgrules.conf <<"CONFIG"
solr            memory          limited
CONFIG
