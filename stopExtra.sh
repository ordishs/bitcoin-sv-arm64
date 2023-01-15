#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

EXE=$DIR/bitcoin/bin/bitcoin-cli

$EXE -rpcport=48332 -datadir=$DIR/bitcoin-data stop
$EXE -rpcport=58332 -datadir=$DIR/bitcoin-data stop
