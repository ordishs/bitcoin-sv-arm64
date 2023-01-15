#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoin-cli
$EXE -conf=$DIR/bitcoin-data/bitcoin.conf -datadir=$DIR/bitcoin-data stop

launchctl unload ~/Library/LaunchAgents/bitcoind.plist
