FROM ubuntu:trusty
MAINTAINER Takahiro Shizuki <shizu@futuregadget.com>

ENV HOME /root
ENV SHELL /bin/bash

# set package repository mirror
#RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list

# Install dependencies
RUN apt-get update -o Acquire::ForceIPv4=true
RUN apt-get install -y bzip2 curl git libgnutls28 man psmisc software-properties-common tmux vim wget
RUN apt-get clean

# Install git latest
RUN add-apt-repository -y ppa:git-core/ppa
RUN apt-get update -o Acquire::ForceIPv4=true
RUN apt-get install -y git


# install x window relations
RUN apt-get -y install python-appindicator xterm xfce4-terminal leafpad vim-gtk
RUN apt-get clean


#install Emacs24.5
RUN apt-get -y install build-essential
RUN apt-get -y build-dep emacs24
RUN mkdir -p /root/src
WORKDIR /root/src
RUN wget http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
RUN tar -xf emacs-24.5.tar.*
WORKDIR /root/src/emacs-24.5
RUN ./configure && make && make install


# install japanese packages
#RUN wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | apt-key add -
#RUN wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | apt-key add -
#RUN wget https://www.ubuntulinux.jp/sources.list.d/wily.list -O /etc/apt/sources.list.d/ubuntu-ja.list
#RUN apt-get update -o Acquire::ForceIPv4=true
#RUN apt-get -y install language-pack-ja-base language-pack-ja fonts-ipafont-gothic dbus-x11 ibus-anthy
#RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
#RUN apt-get clean

#ENV LANG ja_JP.UTF-8
#ENV LC_ALL ja_JP.UTF-8
#ENV LC_CTYPE ja_JP.UTF-8

#ENV GTK_IM_MODULE ibus
#ENV QT_IM_MODULE ibus
#ENV XMODIFIERS @im=ibus
#RUN echo "ibus-daemon -drx" >> ~/.bashrc


# Install spacemacs
RUN git clone --recursive https://github.com/syl20bnr/spacemacs ~/.emacs.d


# Install nvm and node.js
ENV NODE_VERSION v4.2.6
RUN git clone https://github.com/creationix/nvm.git /root/.nvm
RUN echo "if [[ -s /root/.nvm/nvm.sh ]] ; then source /root/.nvm/nvm.sh ; fi" > /root/.bash_profile
RUN /bin/bash -c 'source /root/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION && ln -s /root/.nvm/versions/node/$NODE_VERSION/bin/node /usr/bin/node && ln -s /root/.nvm/versions/node/$NODE_VERSION/bin/npm /usr/bin/npm'


# Install SBCL from the tarball binaries.
RUN wget http://prdownloads.sourceforge.net/sbcl/sbcl-1.3.1-x86-64-linux-binary.tar.bz2	 -O /root/src/sbcl.tar.bz2 \
&&    mkdir /root/src/sbcl \
&&    tar jxvf /root/src/sbcl.tar.bz2 --strip-components=1 -C /root/src/sbcl/ \
&&    cd /root/src/sbcl \
&&    sh install.sh \
&&    rm -rf /root/src/sbcl/

WORKDIR /root/src/sbcl
RUN wget http://beta.quicklisp.org/quicklisp.lisp
ADD install.lisp /root/src/sbcl/install.lisp

RUN sbcl --non-interactive --load /root/src/sbcl/install.lisp


# OpenGL env
env LIBGL_ALWAYS_INDIRECT 1
#env DRI_PRIME 1


WORKDIR /root
