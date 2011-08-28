#!/bin/bash

sudo ifconfig eth0 mtu 1492

# Installing  pre-reqs
sudo aptitude install openjdk-6-jre openjdk-6-jdk subversion build-essential zlib1g-dev g++ curl libssl-dev vim unzip wget -y

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

sudo useradd imon -m -s /bin/bash

setupprofile() {
	echo '# dev profile' > ~/.devprofile
	echo 'export PATH=/mnt/local/git/bin:$PATH' >> ~/.devprofile
	echo 'export PATH=/mnt/local/node/bin:$PATH' >> ~/.devprofile
	echo 'export NODE_PATH=/mnt/local/node:/mnt/local/node/lib/node_modules' >> ~/.devprofile

	sed -i 's/#alias ll/alias ll/' ~/.bashrc
  if [ ! grep '.devprofile' ~/.bashrc ]
  then
    echo 'source ~/.devprofile' >> ~/.bashrc
  fi

	source ~/.bashrc
}

export -f setupprofile
su imon -c "setupprofile"

rm -rf /mnt/*
mkdir -vp /mnt/setup;mkdir -vp /mnt/softwares;mkdir -vp /mnt/workspace;mkdir -vp /mnt/.m2;mkdir -vp /mnt/.ivy2;mkdir -vp /mnt/local
sudo chown -R imon:imon /mnt

# setup git
setupgit() {
  cd /mnt/setup
  wget http://kernel.org/pub/software/scm/git/git-1.7.3.5.tar.bz2
  tar xf git-1.7.3.5.tar.bz2
  cd git-1.7.3.5
  ./configure --prefix=/mnt/local/git --without-tcltk
  make
  make install
}

export -f setupgit
su imon -c "setupgit"

setupnode() {
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
