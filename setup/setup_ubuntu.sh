#!/bin/bash

sudo ifconfig eth0 mtu 1492

if [ ! -e $HOME/upgraded ]
then

locale-gen en_US en_US.UTF-8; dpkg-reconfigure locales
echo "127.0.0.1               localhost.localdomain localhost ubuntu" > /etc/hosts

cat > /etc/apt/sources.list <<END
deb http://archive.ubuntu.com/ubuntu karmic main
deb http://security.ubuntu.com/ubuntu karmic-security main

deb http://gb.archive.ubuntu.com/ubuntu/ karmic universe
deb-src http://gb.archive.ubuntu.com/ubuntu/ karmic universe

deb http://gb.archive.ubuntu.com/ubuntu/ karmic multiverse
deb-src http://gb.archive.ubuntu.com/ubuntu/ karmic multiverse
END

sudo aptitude update -y

sudo apt-get install update-manager-core -y

cat > /etc/update-manager/release-upgrades  <<END
# default behavior for the release upgrader
#

[DEFAULT]
# default prompting behavior, valid options:
#  never  - never prompt for a new distribution version
#  normal - prompt if a new version of the distribution is available
#  lts    - prompt only if a LTS version of the distribution is available
Prompt=normal
END

touch $HOME/upgraded

sudo do-release-upgrade

sudo reboot

else
  echo "Already upgraded"
fi

# Installing  pre-reqs
sudo aptitude install git-core openjdk-6-jre openjdk-6-jdk subversion build-essential  zlib1g-dev g++ curl libssl-dev vim unzip wget -y

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

# for git http support
# download and compile expat
wget http://downloads.sourceforge.net/project/expat/expat/2.0.1/expat-2.0.1.tar.gz
tar xf expat-2.0.1.tar.gz
cd expat-2.0.1/
./configure
make
make install

# download curl dev
aptitude install libcurl-dev libcurl4 libcurl4-dev

sudo useradd imon -m -s /bin/bash

setupprofile() {
	echo '# dev profile' > ~/.devprofile
	echo 'export PATH=/mnt/local/node/bin:$PATH' >> ~/.devprofile
	echo 'export NODE_PATH=/mnt/local/node:/mnt/local/node/lib/node_modules' >> ~/.devprofile

	sed -i 's/#alias ll/alias ll/' ~/.bashrc
	source ~/.bashrc
}

export -f setupprofile
su imon -c "setupprofile"

rm -rf /mnt/*
mkdir -vp /mnt/setup;mkdir -vp /mnt/softwares;mkdir -vp /mnt/workspace;mkdir -vp /mnt/.m2;mkdir -vp /mnt/.ivy2;mkdir -vp /mnt/local
sudo chown -R imon:imon /mnt

setupnode() {
	source ~/.devprofile

	git --version

	cd /mnt/setup
	git clone --depth 1 git://github.com/joyent/node.git
	cd node
	git checkout origin/v0.4 
	export JOBS=2 
	./configure --prefix=/mnt/local/node
	make
	make install

	source ~/.devprofile
	node --version

	curl http://npmjs.org/install.sh | sh
	npm --version
	npm install jslint -g
}

export -f setupnode
su imon -c "setupnode"

exit 0