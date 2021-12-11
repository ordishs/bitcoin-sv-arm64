#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoin-cli
$EXE -datadir=$DIR/bitcoin-data $@

