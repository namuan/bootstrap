#!/bin/bash

INSTALL_DIR=/mnt/setup
WORK_HOME=/mnt/local

cd $INSTALL_DIR
wget http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-1.8.3.tgz
tar xf mongodb-linux-x86_64-1.8.3.tgz
mv mongodb-linux-x86_64-1.8.3 $WORK_HOME/mongodb
echo 'export PATH='$WORK_HOME'/mongodb/bin:$PATH' >> ~/.devprofile
source ~/.devprofile

mkdir $WORK_HOME/data
#mongod --dbpath $WORK_HOME/data
