downloads=./downloads
rm -rf $downloads
mkdir $downloads


version=23.0
wget --output-document=${downloads}/SHA256SUMS.asc https://bitcoincore.org/bin/bitcoin-core-${version}/SHA256SUMS.asc

wget --output-document=${downloads}/bitcoin-${version}-x86_64-linux-gnu.tar.gz https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}-x86_64-linux-gnu.tar.gz


echo "Finished"
