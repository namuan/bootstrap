#!/bin/bash

yum update -y
yum install vim-enhanced zlib zlib-devel -y
yum groupinstall 'Development Tools' -y

rm -rf /mnt/*
mkdir -vp /mnt/setup;mkdir -vp /mnt/softwares;mkdir -vp /mnt/workspace;mkdir -vp /mnt/.m2;mkdir -vp /mnt/.ivy2;mkdir -vp /mnt/local
