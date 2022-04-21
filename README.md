# Build bitcoin-sv for an M1 Mac.

### 1. Firstly, you will need homebrew installed on your machine
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install the following packages:
```
brew install boost@1.76

brew install openssl

brew install zmq

brew install libevent

brew install berkeley-db@4

brew install pkg-config
```


__The latest binaries are available [here](https://github.com/ordishs/bitcoin-sv-arm64/tree/main/bitcoin-sv-1.0.10-arm64).  If you don't want to compile bitcoin on you machine, you can use these pre-built binaries and skip to step 6.__

> Please note that at the time of writing, boost v1.76.0 was the latest version of boost in Homebrew.  If you do not specify the correct version the pre-built binaries may not work.  There is also a gotcha with Homebrew that when you install a specific version of a library, it will not use the default naming folder for the destination: instead it appends the version number to it.  This will cause the pre-built binaries to fail because the location of the dynamic library does not exist.  Read the error messages carefully and keep your head - you may need to do some renaming.



### 3. Set the version and download the source:
```
export BITCOIN_VERSION=1.0.10

mkdir bitcoin-sv-$BITCOIN_VERSION-src
cd bitcoin-sv-$BITCOIN_VERSION-src

curl -O https://download.bitcoinsv.io/bitcoinsv/$BITCOIN_VERSION/bitcoin-sv-$BITCOIN_VERSION.tar.gz

tar xvfz bitcoin-sv-$BITCOIN_VERSION.tar.gz

cd bitcoin-sv-$BITCOIN_VERSION
```

### 4. Configure the build on your machine
```
CPPFLAGS="-I/opt/homebrew/Cellar/libevent/2.1.12/include" LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/Cellar/libsodium/1.0.18_1 -L/opt/homebrew/Cellar/zeromq/4.3.4 -L/opt/homebrew/Cellar/libevent/2.1.12 -L/opt/homebrew/opt/berkeley-db@4/lib" ./configure --with-boost=/opt/homebrew/Cellar/boost@1.76/1.76.0 --disable-tests --disable-bench --prefix $PWD/../../bitcoin-sv-$BITCOIN_VERSION-arm64
```

### 5. Build the binaries:
```
make

make install

cd ../..
```

### 6. Setup your environment:
```
ln -s bitcoin-sv-$BITCOIN_VERSION-arm64 bitcoin
mkdir bitcoin-data

cat << EOL > bitcoin-data/bitcoin.conf
port=18333
rpcbind=0.0.0.0
rpcport=18332
rpcuser=bitcoin
rpcpassword=bitcoin
rpcallowip=0.0.0.0/0
dnsseed=0
listenonion=0
listen=1
server=1
rest=1
regtest=1
debug=1
usecashaddr=0
txindex=1
excessiveblocksize=1000000000
maxstackmemoryusageconsensus=100000000
genesisactivationheight=1
zmqpubhashblock=tcp://*:28332
zmqpubhashtx=tcp://*:28332
zmqpubdiscardedfrommempool=tcp://*:28332
zmqpubremovedfrommempoolblock=tcp://*:28332

zmqpubinvalidtx=tcp://*:28332
invalidtxsink=ZMQ

minminingtxfee=0.0000005
EOL
```

### 7. Optionally, create scripts to start bitcoind and run bitcoin-cli
###

vi start.sh

```
#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoind
$EXE -conf=$DIR/bitcoin-data/bitcoin.conf -datadir=$DIR/bitcoin-data -daemon -standalone

chmod 755 start.sh
```

vi b.sh

```
#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoin-cli
$EXE -datadir=$DIR/bitcoin-data $@

chmod 755 b.sh
```

### 8. Start bitcoind
```
./start.sh
```

### 9. Run bitcoin-cli commands:
```
./b.sh getinfo
./b.sh generate 101
```

### 10. To have Bitcoin start as a service on your Mac

There is a script that will create the appropriate bitcoind.plist file:

```
./enable.sh

launchctl load -w ~/Library/LaunchAgents/bitcoind.plist
```
