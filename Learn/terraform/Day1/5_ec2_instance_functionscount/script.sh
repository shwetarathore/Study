#!/bin/bash

# install httpd
yum update
yum -y install httpd

# make sure httpd is started
service httpd start
