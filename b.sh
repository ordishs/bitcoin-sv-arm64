#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

EXE=$DIR/bitcoin/bin/bitcoin-cli

$EXE -rpcclienttimeout=30 -datadir=$DIR/bitcoin-data $@