#!/bin/bash

source setup_centos_dev_env.sh

SETUP_DIR=/mnt/setup

mkdir -vp $SETUP_DIR

cd $SETUP_DIR

wget ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p352.tar.gz
tar xf ruby-1.8.7-p352.tar.gz 
cd ruby-1.8.7-p352
./configure
make
make install
cd ..
ruby --version

# installing openssl with ruby
yum install openssl.x86_64 openssl-devel.x86_64 -y
cd $SETUP_DIR/ruby-1.8.7-p352/ext/openssl/
ruby extconf.rb 
make
make install

wget http://rubyforge.org/frs/download.php/45905/rubygems-1.3.1.tgz
tar xf rubygems-1.3.1.tgz 
cd rubygems-1.3.1
ruby setup.rb 
gem update --system
gem --version
gem install rake --no-ri --no-rdoc 

#setup sqlite driver 
cd $SETUP_DIR
wget http://sqlite.org/sqlite-amalgamation-3.6.23.1.tar.gz
tar xf sqlite-amalgamation-3.6.23.1.tar.gz 
cd sqlite-3.6.23.1/
./configure 
make
make install
