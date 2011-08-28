#!/bin/bash

sudo ifconfig eth0 mtu 1492

yum update -y
yum install vim-enhanced zlib zlib-devel -y
yum groupinstall 'Development Tools' -y


sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart

sudo useradd imon -m -s /bin/bash

setupprofile() {
        echo '# dev profile' > ~/.devprofile
        echo 'export PATH=/mnt/local/git/bin:$PATH' >> ~/.devprofile
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

# setup ruby
setupruby() {
    cd /mnt/setup



}

exit 0
