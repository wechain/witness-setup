#!/bin/bash

# build-tools.sh - a script to build steemd and cli_wallet. Aimed at Ubuntu Server 16.04 LTS

# colors
BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"

echo $GREEN"build-tools, builing tools for steem witness"

# running as root
if [ "$EUID" -ne 0 ]
	then echo $RED"Please run this script as root"
echo $RESET
	exit
fi

# update system
echo $CYAN"Installing dependencies..."$RESET
apt-get update
apt-get install -y autoconf automake cmake g++ git libssl-dev libtool make pkg-config
apt-get install -y libboost-chrono-dev libboost-context-dev libboost-coroutine-dev libboost-date-time-dev libboost-filesystem-dev libboost-iostreams-dev libboost-locale-dev libboost-program-options-dev libboost-serialization-dev libboost-signals-dev libboost-system-dev libboost-test-dev libboost-thread-dev
apt-get install -y doxygen libncurses5-dev libreadline-dev perl

echo $CYAN"Downloading steem source..."$RESET
git clone https://github.com/steemit/steem
cd steem
git checkout stable

echo $CYAN"Set up build environment..."$RESET
git submodule update --init --recursive
mkdir build
cd build
cmake -DLOW_MEMORY_NODE=ON -DCMAKE_BUILD_TYPE=Release ..

echo $CYAN"Make tools..."$RESET
echo $CYAN"(1/2) Make steemd..."$RESET
make -j$(nproc) steemd
echo $CYAN"(2/2) Make cli_wallet..."$RESET
make -j$(nproc) cli_wallet
echo $CYAN"Install tools..."$RESET
make install

cd ..
cd ..

echo
echo $GREEN"Finished installing steem witness tools"$RESET