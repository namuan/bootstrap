#!/bin/bash

mnt=/mnt
LOCAL=/mnt/local
SETUP=/mnt/setup
WORKSPACE=/mnt/workspace
SOFTWARES=/mnt/softwares
TEMP=/mnt/temp

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
 	echo "export PATH=/mnt/local/git/bin:/mnt/local/ruby/bin:$PATH" >> ~/.devprofile
	echo "export NODE_PATH=/mnt/local/node:/mnt/local/node/lib/node_modules" >> ~/.devprofile

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

mkdir -vp /mnt/setup;mkdir -vp /mnt/softwares;mkdir -vp /mnt/workspace;mkdir -vp /mnt/local
sudo chown -R imon:imon /mnt

# setup git
setupgit() {

  source ~/.bashrc

  if [ -e /mnt/local/git/bin/git ]
  then
    echo "git already installed"
    git --version   
  else
    cd /mnt/setup
    wget http://kernel.org/pub/software/scm/git/git-1.7.3.5.tar.bz2
    tar xf git-1.7.3.5.tar.bz2
    cd git-1.7.3.5
    ./configure --prefix=/mnt/local/git --without-tcltk
    make
    make install
  fi
}

export -f setupgit
su imon -c "setupgit"

setupruby() {
  source ~/.bashrc
  
  if [ -e /mnt/local/ruby/bin/ruby ]
  then
    echo "ruby already installed"
    ruby --version
  else
  
    cd /mnt/setup
    wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p0.tar.gz
    tar xf  ruby-1.9.2-p0.tar.gz
    cd ruby-1.9.2-p0
    ./configure --prefix=/mnt/local/ruby
    make
    make install

  fi
}

export -f setupruby
su imon -c "setupruby"

setuprubygems() {
  source ~/.bashrc
  if [ -e /mnt/local/ruby/bin/gem ]
  then
    echo "rubygems already installed"
    gem --version
  else
    cd /mnt/setup
    wget  http://production.cf.rubygems.org/rubygems/rubygems-1.8.7.tgz
    tar xf rubygems-1.8.7.tgz
    cd rubygems-1.8.7
    ruby setup.rb
    gem update --system
  fi
}

export -f setuprubygems
su imon -c "setuprubygems"

exit 0
