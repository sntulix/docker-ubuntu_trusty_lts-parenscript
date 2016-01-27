FROM ubuntu:vivid
MAINTAINER Takahiro Shizuki <shizu@futuregadget.com>

# Install dependencies from Debian repositories
RUN apt-get update -o Acquire::ForceIPv4=true \
&& apt-get install -y bzip2 curl git make tmux vim  wget \
&& apt-get clean

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

ENV HOME /root

WORKDIR /tmp/
RUN wget http://beta.quicklisp.org/quicklisp.lisp
ADD install.lisp /tmp/install.lisp

RUN sbcl --non-interactive --load /tmp/install.lisp

WORKDIR /root
