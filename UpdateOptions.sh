#!/bin/bash
mac=$(cat /sys/class/net/eth0/address)
var=${mac//:}
repo=/home/root/usr/AskRepo
defaultRepo=/home/root/usr/DefaultRepo
addressDatabase=ipDatabase.txt
currentTime=$(date +"%m-%d-%y_%H%M")



echo "What interface?"
read interfaceName
cd
cd $repo

ip=$(/sbin/ifconfig $interfaceName | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
#Downloading main group options
echo "Removing ip from system"
cd
rm -rf $defaultRepo
git clone https://AskLab:student123@github.com/AskLab/Default.git $defaultRepo
echo $ip
sed -i '/'$ip'/d' $defaultRepo/$addressDatabase
read key

cd $repo
git checkout $var
git pull origin master

bash setIpScript.sh $interface
cp -f /etc/network/interfaces $repo
git add interfaces
git commit -m "$currentTime"
git push -u origin $var

#Saving latest address Database
read key
cd $defaultRepo
git add $addressDatabase
git commit -m "$var"
git push -u origin master

echo "Updated"
