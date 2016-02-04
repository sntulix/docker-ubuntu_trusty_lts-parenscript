FROM ubuntu:trusty
MAINTAINER Takahiro Shizuki <shizu@futuregadget.com>

ENV HOME /root

# Install dependencies
RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
RUN apt-get update -o Acquire::ForceIPv4=true
RUN apt-get install -y bzip2 curl git make man psmisc tmux vim wget
RUN apt-get clean


# install x window relations
RUN apt-get update
RUN apt-get -y install dbus-x11 ibus python-appindicator xterm xfce4-terminal leafpad emacs vim-gtk
RUN apt-get clean

ENV GTK_IM_MODULE ibus
ENV QT_IM_MODULE ibus
ENV XMODIFIERS @im=ibus
RUN echo "ibus-daemon -drx" >> ~/.bashrc


# install japanese packages
RUN wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | apt-key add -
RUN wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | apt-key add -
RUN wget https://www.ubuntulinux.jp/sources.list.d/wily.list -O /etc/apt/sources.list.d/ubuntu-ja.list
RUN apt-get update
RUN apt-get -y install language-pack-ja-base language-pack-ja fonts-ipafont-gothic ibus-anthy
RUN update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja
RUN apt-get clean

ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8


# Install spacemacs
RUN git clone --recursive https://github.com/syl20bnr/spacemacs ~/.emacs.d


# Install nvm and node.js
ENV NODE_VERSION v4.2.6
RUN git clone https://github.com/creationix/nvm.git /root/.nvm
RUN echo "if [[ -s /root/.nvm/nvm.sh ]] ; then source /root/.nvm/nvm.sh ; fi" > /root/.bash_profile
RUN /bin/bash -c 'source /root/.nvm/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && nvm alias default $NODE_VERSION && ln -s /root/.nvm/versions/node/$NODE_VERSION/bin/node /usr/bin/node && ln -s /root/.nvm/versions/node/$NODE_VERSION/bin/npm /usr/bin/npm'


# Install SBCL from the tarball binaries.
RUN wget http://prdownloads.sourceforge.net/sbcl/sbcl-1.3.1-x86-64-linux-binary.tar.bz2	 -O /tmp/sbcl.tar.bz2 \
&&    mkdir /tmp/sbcl \
&&    tar jxvf /tmp/sbcl.tar.bz2 --strip-components=1 -C /tmp/sbcl/ \
&&    cd /tmp/sbcl \
&&    sh install.sh \
&&    cd /tmp \
&&    rm -rf /tmp/sbcl/

WORKDIR /tmp/
RUN wget http://beta.quicklisp.org/quicklisp.lisp
ADD install.lisp /tmp/install.lisp

RUN sbcl --non-interactive --load /tmp/install.lisp


# OpenGL env
env LIBGL_ALWAYS_INDIRECT 1
#env DRI_PRIME 1


WORKDIR /root
