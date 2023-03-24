#!/bin/bash

if [ -L "$0" ]; then
  DIR="$(cd "$($(pwd)/$(readlink "$0"))" && pwd)"
else
  DIR="$(cd "$(dirname "$0")" && pwd)"
fi

mkdir -p ~/Library/LaunchAgents

cat << EOL > ~/Library/LaunchAgents/bitcoind.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
  <key>Label</key>
  <string>bitcoind</string>
  <key>ProgramArguments</key>
  <array>
    <string>$DIR/bitcoin/bin/bitcoind</string>
    <string>-conf=$DIR/bitcoin-data/bitcoin.conf</string>
    <string>-datadir=$DIR/bitcoin-data</string>
    <string>-port=18333</string>
    <string>-rpcport=18332</string>
    <string>-onlynet=ipv4</string>
    <string>-zmqpubhashtx=tcp://*:38332</string>
    <string>-zmqpubhashblock=tcp://*:38332</string>
    <string>-zmqpubhashtx2=tcp://*:38332</string>
    <string>-zmqpubhashblock2=tcp://*:38332</string>
    <string>-zmqpubdiscardedfrommempool=tcp://*:38332</string>
    <string>-zmqpubremovedfrommempoolblock=tcp://*:38332</string>
    <string>-zmqpubinvalidtx=tcp://*:38332</string>
    <string>-invalidtxsink=ZMQ</string>
    <string>-daemon</string>
    <string>-standalone</string>
  </array>
  <key>UserName</key>
  <string>$(whoami)</string>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
</dict>
</plist>
EOL

launchctl load ~/Library/LaunchAgents/bitcoind.plist
