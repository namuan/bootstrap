#!/bin/bash

sudo ifconfig eth0 mtu 1492

set -o errexit
set -o nounset

if [ "$(id -u)" != "0" ]; then
    echo '** Script must be run as root **'
    exit 1
fi

CURRENT_MTU=$( /sbin/ifconfig eth0 | grep MTU | awk '{print $5}' | cut -d: -f2 )

if [ "$CURRENT_MTU" -ge "1500" ]; then
  echo "Changing MTU from 1500 to 1492"
  /sbin/ifconfig eth0 mtu 1492
  sh -c "cat > /etc/network/if-up.d/mtu" <<EOT
#!/bin/sh
ifconfig eth0 mtu 1492
EOT
  chmod 755 /etc/network/if-up.d/mtu
fi

if [ ! -e $HOME/upgraded ]
then

locale-gen en_US en_US.UTF-8; dpkg-reconfigure locales
echo "127.0.0.1               localhost.localdomain localhost ubuntu" > /etc/hosts

cat > /etc/apt/sources.list <<END
#############################################################
################### OFFICIAL UBUNTU REPOS ###################
#############################################################

###### Ubuntu Main Repos
deb http://uk.archive.ubuntu.com/ubuntu/ lucid main universe
deb-src http://uk.archive.ubuntu.com/ubuntu/ lucid main universe

###### Ubuntu Update Repos
deb http://uk.archive.ubuntu.com/ubuntu/ lucid-security main universe
deb http://uk.archive.ubuntu.com/ubuntu/ lucid-updates main universe
deb-src http://uk.archive.ubuntu.com/ubuntu/ lucid-security main universe
deb-src http://uk.archive.ubuntu.com/ubuntu/ lucid-updates main universe
END

aptitude update -q

apt-get install update-manager-core -y

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

echo "Upgrading system"
do-release-upgrade

reboot

else
  echo "Already upgraded"
fi

# Installing  pre-reqs
aptitude install build-essential git-core zlib1g-dev g++ curl libssl-dev unzip wget vim -y

sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

if ! /bin/egrep -i "^admin\:" /etc/group &>/dev/null; then
  echo "Creating the admin group"
  groupadd admin
fi

if ! /bin/egrep -i "^%admin ALL" /etc/sudoers &>/dev/null; then
  echo "Allowing sudo access for the admin group"
cat <<EOF >> /etc/sudoers
# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL
EOF
fi

if ! /bin/egrep -i "imon" /etc/passwd &>/dev/null; then
  echo "Creating user"

  # to generate an encrypted password for useradd:
  # perl -e 'print crypt("SECRET", "password"),"\n"'
  useradd -m -s /bin/bash -G admin -pXXXXXXXX  -m imon

  cp -r ~/.ssh /home/imon/
  chown -R imon:imon /home/imon/.ssh
fi

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