#!/bin/bash

sudo ifconfig eth0 mtu 1492

# for centos 5 run this
wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
rpm -i epel-release-5-4.noarch.rpm

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

yum install git -y

setupnode() {
        source ~/.devprofile

        git --version

        cd /mnt/setup
        git clone --depth 1 git://github.com/joyent/node.git
        cd node
        git checkout origin/v0.4
        export JOBS=2
        ./configure --prefix=/mnt/local/node --without-ssl
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

setupvim() {

cd /mnt/setup
wget https://github.com/scrooloose/nerdtree/zipball/4.1.0
unzip 4.1.0
cd *nerdtree*
mkdir -vp ~/.vim
cp -R * ~/.vim


cat > ~/.vimrc <<END
filetype plugin on
filetype indent on

set tabstop=4
set shiftwidth=4
set smartindent
set autoindent
set showmatch
set ai
syntax on
set number

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

" easy tab navigation
map  <C-l> :tabn<CR>
map  <C-k> :tabp<CR>
map  <C-n> :tabnew<CR>
map  <F2> <Esc>:wqa<CR>

" run make and node
nmap <F4> :w<CR>:make<CR>:cw<CR>
map <F5> :w<CR>:!node %:p<CR>
imap <F5> <Esc>:w<CR>:!node %:p<CR>

" code formatting
map <F3> <Esc>gg=G<CR>:w<CR>
imap <F3> <Esc>gg=G<CR>:w<CR>
END

mkdir -vp ~/.vim/ftplugin

cat > ~/.vim/ftplugin/javascript.vim <<END
setlocal makeprg=jslint\ %
setlocal errorformat=%-P%f,
\%-G/*jslint\ %.%#*/,
\%*[\ ]%n\ %l\\,%c:\ %m,
\%-G\ \ \ \ %.%#,
\%-GNo\ errors\ found.,
\%-Q
END

}

export -f setupvim
su imon -c "setupvim"

exit 0
