set -e
echo "Running $0 with arguments '$@'..."
if [ $# -ne 2 ]; then
  echo 1>&2 "Usage:  $0 [chain] [datadir]"
  echo 1>&2 "Example $0 test /mnt/data"
  exit 3
fi
bitcoin_conf_chain=$1
bitcoin_conf_datadir=$2

downloads=${HOME}/downloads
bitcoin_core=${HOME}/bitcoin_core

rm -rf $downloads $bitcoin_core
rm -f ${HOME}/.bitcoin/bitcoin.conf
rm -rf ${bitcoin_conf_datadir}/*
mkdir -p $downloads $bitcoin_core ${HOME}/.bitcoin ${bitcoin_conf_datadir}

version=23.0
wget --output-document=${downloads}/SHA256SUMS.asc https://bitcoincore.org/bin/bitcoin-core-${version}/SHA256SUMS.asc
wget --output-document=${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}-x86_64-linux-gnu.tar.gz
tar -zxf ${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz --directory $bitcoin_core
echo "[INFO] Extract completed into ${bitcoin_core}"

echo "#Configuration created by '$0'"     >  ${HOME}/.bitcoin/bitcoin.conf
echo "chain=${bitcoin_conf_chain}"      >> ${HOME}/.bitcoin/bitcoin.conf
echo "datadir=${bitcoin_conf_datadir}"  >> ${HOME}/.bitcoin/bitcoin.conf
echo "[INFO] ${HOME}/.bitcoin/bitcoin.conf configured"
cat ${HOME}/.bitcoin/bitcoin.conf
echo ""

cd ${bitcoin_core}/bitcoin-${version}/bin
echo "Launching bitcoind from $(pwd)..."
./bitcoind  -daemon
sleep 20
./bitcoin-cli getblockchaininfo # repeat until initialblockdownload is false
echo "Finished"
