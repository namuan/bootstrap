#!/bin/bash

mkdir -vp /mnt/setup;mkdir -vp /mnt/local
sudo aptitude install openjdk-6-jre openjdk-6-jdk subversion build-essential zlib1g-dev g++ curl libssl-dev vim unzip wget -y
cd /mnt/setup
wget http://mirror.fubra.com/ftp.apache.org//httpd/httpd-2.2.19.tar.gz
tar xf httpd-2.2.19.tar.gz
cd httpd-2.2.19
./configure --prefix=/mnt/local/httpd
make
make install
cd ../../local/
