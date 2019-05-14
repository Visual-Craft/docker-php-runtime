Docker PHP runtime
==================

This is a collection of the Dockerfile's and support tools for building the Docker image used for running different PHP applications.

Currently supports PHP 7.2 and 7.3.

Requirements
------------
* Docker
* make, sh, grep, sed

Build
-----
```sh
# PHP 7.2
$ make php7.2-runtime

# PHP 7.3
$ make php7.3-runtime
```
