downloads=./downloads
bitcoin_core=./bitcoin_core

rm -rf $downloads $bitcoin_core
mkdir $downloads $bitcoin_core ~/.bitcoin

version=23.0
wget --output-document=${downloads}/SHA256SUMS.asc https://bitcoincore.org/bin/bitcoin-core-${version}/SHA256SUMS.asc
wget --output-document=${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}-x86_64-linux-gnu.tar.gz

tar -zxf ${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz --directory $bitcoin_core

echo "chain=test" >> ~/.bitcoin/bitcoin.conf

echo "Finished"
