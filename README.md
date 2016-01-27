Parenscript Dockerfile
====================

This repository contains Dockerfile of Parenscript for Docker's automated build.

It was made with reference to the repository [davazp/docker-quicksbcl](https://github.com/davazp/docker-quicksbcl)

#How to build docker image

```
git clone 
docker build --tag=local/ubuntu_vivid-parenscript docker-ubuntu_vivid-quicksbcl
```

#How to use parenscript
```
docker run -ti local/ubuntu_vivid-parenscript /bin/bash
sbcl --eval '(ql:quickload :parenscript)'
```
