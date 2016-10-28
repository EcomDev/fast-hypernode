#!/bin/bash

apt-get install python-software-properties
add-apt-repository ppa:avsm/ppa
apt-get update -y -f
apt-get install ocaml opam -y


mkdir -p /usr/src/unison/
cd /usr/src/unison/

wget https://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.48.4/unison-2.48.4.tar.gz -O unison.tar.gz
tar xzvf unison.tar.gz  --strip-components 1
make UISTYLE=text || true

chmod +x unison
mv unison /usr/bin/

