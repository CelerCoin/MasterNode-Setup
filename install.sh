#!/bin/bash
# create a swap file for low RAM servers
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile none swap sw 0 0" >> /etc/fstab

# update packages
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get install -y nano git pwgen

# install basic packages
sudo apt-get install -y software-properties-common nano libboost-all-dev libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev
sudo add-apt-repository -y ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

# download and unpack wallet
VER=$(lsb_release -sr)
wget https://github.com/CelerCoin/celer/releases/download/v.0.7.1.2/'Celer-0.7.1.2-Ubuntu'$VER'_x64.tar.gz'
chmod -R 755 ~/'Celer-0.7.1.2-Ubuntu'$VER'_x64.tar.gz'
tar -xvf ~/'Celer-0.7.1.2-Ubuntu'$VER'_x64.tar.gz'

# add MN settings to celer.conf
mkdir ~/.celercore
chmod -R 755 ~/.celercore
rm 'Celer-0.7.1.2-Ubuntu'$VER'_x64.tar.gz'

GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`
echo -e "rpcuser=CelerMN\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}\nbind=${IP_ADD}:13737" > ~/.celercore/celer.conf

# start daemon and get MN key
./celerd -daemon
sleep 10
mnkey=$(./celer-cli masternode genkey)
./celer-cli stop
echo -e "masternode=1\nmasternodeprivkey=$mnkey" >> ~/.celercore/celer.conf
cd ~/.celercore
rm mncache.dat mnpayments.dat
cd ~/
./celerd -daemon -reindex

# install sentinel
sudo apt-get -y install python-virtualenv python-pip virtualenv
git clone https://github.com/CelerCoin/sentinel.git && cd sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
echo "celer_conf=/root/.celercore/celer.conf" >> ~/sentinel/sentinel.conf

# add sentinel to crontab
crontab -l > sentinelcron
echo "* * * * * cd ~/sentinel && ./venv/bin/python bin/sentinel.py 2>&1 >> sentinel-cron.log" >> sentinelcron
crontab sentinelcron
rm sentinelcron

echo "$(tput setaf 5)$(tput setab 7)MASTERNODE AND SENTINEL IS SUCCESSFULLY INSTALLED$(tput sgr 0)"
echo "$(tput setaf 5)$(tput setab 7)MASTERNODE PRIVATE KEY: $mnkey$(tput sgr 0)"