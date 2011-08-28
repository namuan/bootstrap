#!/bin/bash

HOME=/mnt
LOCAL_BIN=$HOME/local
SETUP=$HOME/setup
WORKSPACE=$HOME/workspace
SOFTWARES=$HOME/softwares
TEMP=$HOME/temp

sudo ifconfig eth0 mtu 1492

# Installing  pre-reqs
sudo aptitude install openjdk-6-jre openjdk-6-jdk subversion build-essential zlib1g-dev g++ curl libssl-dev vim unzip wget libyaml-dev libyaml-ruby -y

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

grep 'imon' /etc/passwd
if [ $? -ne 0 ]
then
  sudo useradd imon -m -s /bin/bash
fi

setupprofile() {
	echo '# dev profile' > ~/.devprofile
	echo "export PATH=$LOCAL/git/bin:$PATH" >> ~/.devprofile
	echo "export PATH=$LOCAL/node/bin:$PATH" >> ~/.devprofile
  	echo "export PATH=$LOCAL/ruby/bin:$PATH" >> ~/.devprofile
	echo "export NODE_PATH=$LOCAL/node:$LOCAL/node/lib/node_modules" >> ~/.devprofile

	sed -i 's/#alias ll/alias ll/' ~/.bashrc
	grep '.devprofile' ~/.bashrc
	if [ $? -ne 0 ]
	then
	  echo 'source ~/.devprofile' >> ~/.bashrc
	fi

	source ~/.bashrc
}

export -f setupprofile
su imon -c "setupprofile"

rm -rf $HOME/*
mkdir -vp $SETUP;mkdir -vp $SOFTWARES;mkdir -vp $WORKSPACE;mkdir -vp $LOCAL
sudo chown -R imon:imon /mnt

# setup git
setupgit() {

  source ~/.bashrc

  if [ -e $LOCAL/git/bin/git ]
  then
    git --version   
  else
    cd $SETUP
    wget http://kernel.org/pub/software/scm/git/git-1.7.3.5.tar.bz2
    tar xf git-1.7.3.5.tar.bz2
    cd git-1.7.3.5
    ./configure --prefix=$LOCAL/git --without-tcltk
    make
    make install
  fi
}

export -f setupgit
su imon -c "setupgit"

setupruby() {
  source ~/.bashrc
  
  if [ -e $LOCAL/ruby/bin/ruby ]
  then
    ruby --version
  else
  
    cd $SETUP
    wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p0.tar.gz
    tar xf  ruby-1.9.2-p0.tar.gz
    cd ruby-1.9.2-p0
    ./configure --prefix=$LOCAL/ruby
    make
    make install

  fi
}

export -f setupruby
su imon -c "setupruby"

exit 0
