# Fast Hypernode Vagrant Box

**The fastest Magento Vagrant VM**
Fast Byte Hypernode Box (Uses nfs_guest plugin for file shares)

Based on images from https://github.com/byteinternet/hypernode-vagrant

# Installation

Installation is possible via composer:

```bash
composer create-project --keep-vcs ecomdev/fast-hypernode
```



# Required Vagrant plugins

* vagrant-hostmanager 
* vagrant-auto_network
* vagrant-nfs_guest


# Usage

1. Copy config.rb.dst to config.rb
2. Edit it to reflect your project settings
```ruby
name 'your-project-name'
hostname name + '.box' # will be your main url http://your-project-name.box/
domains %w(www.your-project-name-additional.box) # additional domain names separated by space
profiler true # Add tideways-profiler ?
developer true # Enable development mode?
directory 'server' # Directory into which NFS share will be mounted on your host
```

# Configuration Options

* `name` - name of your node
* `hostname` - default project hostname
* `domains` - list of additional domain names for your project 
* `varnish` - enable or disable varnish for your project (default: `false`)
* `profiler` - enable or disable tideways-profiler (default: `false`)
* `developer` - enable or disable developer mode in Magento (default: `false`)
* `magento2` - Magento 2.0 installment? (default: `false`)
* `install` - Shall Magento be installed? (default: `false`, only Magento 2.0 installation supported)
* `shell` - Install FishShell? (default: `false`)
* `php7` - PHP7 instead of PHP5? (default: `false`)
* `cpu` - number of CPUs to dedicate to your VM (default: `1`)
* `memory` - memory in MB to dedicate to your VM (default: `1024`)
* `user` - User name for nfs share permissions (default: `app`)
* `group` - Group name for nfs share permissions (default: `app`)
* `uid` - User ID of your host to be mapped to linux VM (default: `Process.euid`)
* `gid` - Group ID of your host to be mapped to linux VM (default: `Process.egid`)
* `directory` - Directory to be used as mount on host machine (default: `server`)
* `network` - Network mast for automatical network assignment to VM (default: `33.33.33.0/24`)

# Adding custom shell provisioners

You can easily add more provision shell scripts from configuration file (config.rb):
```ruby
add_shell 'some-custom-shell-script.sh'

# Will provision only if PHP7 flag is turned on
add_shell 'some-custom-script-for-php7.sh', :php7  
```
