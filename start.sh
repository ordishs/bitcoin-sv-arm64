#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoind
$EXE -conf=$DIR/bitcoin-data/bitcoin.conf -datadir=$DIR/bitcoin-data -daemon -standalone

