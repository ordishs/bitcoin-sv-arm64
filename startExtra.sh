#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoind

mkdir -p $DIR/bitcoin-data1
mkdir -p $DIR/bitcoin-data2

$EXE -conf=$DIR/bitcoin-data/bitcoin.conf -datadir=$DIR/bitcoin-data1 -port=48333 -rpcport=48332 -onlynet=ipv4 -addnode=localhost:18333 -addnode=localhost:58333 -daemon

$EXE -conf=$DIR/bitcoin-data/bitcoin.conf -datadir=$DIR/bitcoin-data2 -port=58333 -rpcport=58332 -onlynet=ipv4 -addnode=localhost:18333 -addnode=localhost:48333 -daemon

