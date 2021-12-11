# Build bitcoin-sv for an M1 Mac.

The latest binaries are available [here](https://github.com/ordishs/bitcoin-sv-arm64/tree/main/bitcoin-sv-1.0.10-arm64).  It you download these to your machine, you can skip to step 6.


### 1. Firstly, you will need homebrew installed on your machine


### 2. Install the following packages:
```
brew install boost

brew install openssl

brew install zmq

brew install libevent

brew install berkeley-db@4
```

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
LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib -L/opt/homebrew/Cellar/libsodium/1.0.18_1 -L/opt/homebrew/Cellar/zeromq/4.3.4 -L/opt/homebrew/Cellar/libevent/2.1.12 -L/opt/homebrew/opt/berkeley-db@4/lib" ./configure --with-boost=/opt/homebrew/Cellar/boost/1.76.0 --disable-tests --disable-bench --prefix $PWD/../../bitcoin-sv-$BITCOIN_VERSION-arm64
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

cat << EOL > $PWD/bitcoin-data/bitcoin.conf
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
EOL
```

### 7. Optionally, create scripts to start bitcoind and run bitcoin-cli
###

vi $PWD/start.sh

```
#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoind
$EXE -conf=$DIR/bitcoin-data/bitcoin.conf -datadir=$DIR/bitcoin-data -daemon -standalone

chmod 755 start.sh
```

vi $PWD/b.sh

```
#!/bin/bash
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
EXE=$DIR/bitcoin/bin/bitcoin-cli
$EXE -datadir=$DIR/bitcoin-data $@

chmod 755 b.sh
```

