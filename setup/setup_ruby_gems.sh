#!/bin/bash

mkdir -vp /mnt/setup;mkdir -vp /mnt/local
cd /mnt/setup

CONFIG_DIR=/mnt/local

wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p352.tar.gz
tar xf ruby-1.8.7-p352.tar.gz 
cd ruby-1.8.7-p352
./configure --prefix=${CONFIG_DIR}
make
make install
cd ..
ruby --version

wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar xf rubygems-1.3.1.tgz 
cd rubygems-1.3.1
ruby setup.rb 
gem update --system
gem --version
gem install rake --no-ri --no-rdoc 
