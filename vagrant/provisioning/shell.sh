#!/bin/bash

if [ ! -f /usr/bin/fish ]
then
    sudo apt-get install -y python-software-properties
    sudo apt-add-repository ppa:fish-shell/release-2
    sudo apt-get update
    sudo apt-get install -y fish
    sudo sh -c 'echo /usr/bin/fish >>/etc/shells'
    sudo chsh -s /usr/bin/fish app
fi
