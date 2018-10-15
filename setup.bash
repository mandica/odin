#!/bin/bash

#Welcome message
echo "Welcome to mrblister's VPS masternode setup"  
echo "This script will now install your masternode."
sleep 3

#Update the VPS server.  Uncomment if you want to update the server.
#sudo apt update
#sudo apt dist-upgrade -y

#Turn swap on, not needed but maybe will be useful in future.
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
sudo mkswap /var/swap.img
sudo chmod 600 /var/swap.img
sudo swapon /var/swap.img

#Get odin binaries
mkdir Downloads
wget https://github.com/odinblockchain/Odin/releases/download/v1.4.2/odin-1.4.2-x86_64-linux-gnu.tar.gz -P ~/Downloads/
cd Downloads
tar xvzf ~/Downloads/odin-1.4.2-x86_64-linux-gnu.tar.gz 
sudo cp odin-1.4.2/bin/odin* /usr/bin/. && cd

#Set up initial odin.conf file.  The auto ipaddress might not work if multiple adapters, so I prompt for IP instead.
#present (like for ipv6 and ipv4).
mkdir ~/.odin
config=~/.odin/odin.conf 
#ipaddress=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
echo "Enter your VPS IP address, and press [ENTER]"
read ipaddress
echo "staking=1" >> $config
echo "listen=1" >> $config
echo "daemon=1" >> $config
echo "logtimestamps=1" >> $config
echo "maxconnections=256" >> $config
echo "externalip=$ipaddress" >> $config
echo "masternodeaddr=$ipaddress" >> $config


#start odind to get mn private key and append to odin.conf, restart odind. 
odind
sleep 1
mnkey=$(odin-cli masternode genkey)
echo "masternode=1" >> $config
echo "masternodeprivkey=$mnkey" >> $config
odin-cli stop
odind

echo " "
echo "Masternode VPS setup complete."
echo "(it will now take a few minutes for the mn to get ready)"
echo " "
echo "You can now complete the setup using the Odin gui wallet."
echo " "
echo "The masternode ip address you entered was:"
echo "$ipaddress"
echo "Your masternode private key is:"
echo "$mnkey"
echo " "
 
