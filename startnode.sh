downloads=${HOME}/downloads
bitcoin_core=${HOME}/bitcoin_core
vol_label=btc_node_data

rm -rf $downloads $bitcoin_core
rm ${HOME}/.bitcoin/bitcoin.conf
rm -rf ${HOME}/datadir
mkdir $downloads $bitcoin_core ${HOME}/.bitcoin ${HOME}/datadir

version=23.0
wget --output-document=${downloads}/SHA256SUMS.asc https://bitcoincore.org/bin/bitcoin-core-${version}/SHA256SUMS.asc
wget --output-document=${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}-x86_64-linux-gnu.tar.gz
tar -zxf ${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz --directory $bitcoin_core
echo "[INFO] Extract completed into ${bitcoin_core}"

# echo "chain=test" > ${HOME}/.bitcoin/bitcoin.conf
# echo "[INFO] ${HOME}/.bitcoin/bitcoin.conf configured"

cd ${bitcoin_core}/bitcoin-${version}/bin
echo "Launching bitcoind from $(pwd)..."
./bitcoind  -datadir=${HOME}/datadir -chain=test -daemon
sleep 20
./bitcoin-cli -datadir=${HOME}/datadir -chain=test getblockchaininfo # repeat until initialblockdownload is false
# ./bitcoin-cli help
ls -al

echo "Finished"
