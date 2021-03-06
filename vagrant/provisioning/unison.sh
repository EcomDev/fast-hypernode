#!/bin/bash

apt-get update
apt-get install libdpkg-perl=1.18.4ubuntu1 -y -f --allow-downgrades
apt-get install ocaml ocaml-native-compilers camlp4-extra opam -y -f

mkdir -p /usr/src/unison/
cd /usr/src/unison/

wget https://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.51.2/unison-2.51.2.tar.gz -O unison.tar.gz
tar xzvf unison.tar.gz  --strip-components 1
make UISTYLE=text || true

chmod +x unison unison-*
rm /usr/bin/unison
rm /usr/bin/unison-*

ln -s $PWD/unison /usr/bin/
ln -s $PWD/unison-* /usr/bin/

echo "fs.inotify.max_user_watches=262144" > /etc/sysctl.d/90-unison-notify.conf
sysctl -p --system
