#! /bin/bash

# To download Pintos project and patched bochs

wget https://web.stanford.edu/class/cs140/projects/pintos/pintos.tar.gz
wget https://web.stanford.edu/class/cs140/projects/pintos/bochs-2.2.6-pintos.tar.gz


# To extract *.tar.gz files

tar -zxf pintos.tar.gz


# Rename bochs file for installation script

mv bochs-2.2.6-pintos.tar.gz bochs-2.2.6.tar.gz


# To install gcc-4.8, g++-4.8 and other required package

echo "" | sudo tee -a /etc/apt/sources.list
echo "# Previous version of repository for gcc-4.8, g++-4.8" | sudo tee -a /etc/apt/sources.list
echo "deb http://kr.archive.ubuntu.com/ubuntu/ xenial main" | sudo tee -a /etc/apt/sources.list
echo "deb http://kr.archive.ubuntu.com/ubuntu/ xenial universe" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install -y gcc-4.8 g++-4.8 build-essential libncurses5 libncurses5-dev xorg-dev expect


# Change gcc and g++ version

bin='/usr/bin'
sudo rm $bin/gcc $bin/g++
sudo ln -s gcc-4.8 $bin/gcc
sudo ln -s g++-4.8 $bin/g++


# Patch for bochs installation script

patch -d./pintos/src/misc < patch/bochs-2.2.6-build.patch


# Install bochs-2.2.6 for pintos with pintos script

SRCDIR=`pwd -P`
PINTOSDIR=`pwd -P`/pintos
DSTDIR=/usr/local
sudo env SRCDIR=$SRCDIR PINTOSDIR=$PINTOSDIR DSTDIR=$DSTDIR sh ./pintos/src/misc/bochs-2.2.6-build.sh


# Add PATH environment variable for Pintos

echo "" >> $HOME/.bashrc
echo "export PATH=\"\$PATH:$PINTOSDIR/src/utils\"" >> $HOME/.bashrc


# Patch for Pintos and Makefile

patch -d./pintos/src/utils < patch/pintos.patch
patch -d./pintos/src/utils < patch/Makefile.patch


# Patch for pintos-gdb

sed -i "/GDBMACROS=\/usr\/class\/cs140\/pintos\/pintos\/src\/misc\/gdb-macros/c\GDBMACROS=$PINTOSDIR/src/misc/gdb-macros" $PINTOSDIR/src/utils/pintos-gdb
