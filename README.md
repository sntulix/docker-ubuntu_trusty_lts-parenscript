Parenscript Dockerfile
====================

This repository contains Dockerfile of Parenscript for Docker's automated build.

It was made with reference to the repository [davazp/docker-quicksbcl](https://github.com/davazp/docker-quicksbcl)

#How to build docker image

```
git clone 
docker build --tag=local/ubuntu_trusty_lts-parenscript docker-ubuntu_trusty_lts-parenscript
```

#How to use parenscript
```
#
#docker run -ti --rm -e DISPLAY=192.168.99.1:0 -v /c/Users/xyz:/mnt/home local/ubuntu_trusty_lts-parenscript /bin/bash
#docker run -ti --rm -e DISPLAY=192.168.99.1:0 local/ubuntu_trusty_lts-parenscript /bin/bash
docker run -ti --rm local/ubuntu_trusty_lts-parenscript /bin/bash
sbcl --eval '(ql:quickload :parenscript)'
```

#Installed packages
* build-essential
* bzip2
* curl
* emacs24.5.spacemacs
* git
* gnutls28
* leafpad
* make
* man
* node.js v4.2.6
* npm
* parenscript
* psmisc
* python-appindicator
* sbcl v1.3.1
* tmux
* vim
* vim-gtk
* wget
* xfce4-terminal
* xterm

# option packages (commentout)
* ja-packages
  * dbus-x11
  * fonts-ipafont-gothic
  * ibus-anthy
  * language-pack-ja
  * language-pack-ja-base
