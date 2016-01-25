#!/bin/bash
mac=$(cat /sys/class/net/eth0/address)
var=${mac//:}
repo=/home/root/usr/AskRepo
defaultRepo=/home/root/usr/DefaultRepo
addressDatabase=ipDatabase.txt
currentTime=$(date +"%m-%d-%y_%H%M")

echo "Which interface you want to reset?"
read interfaceName

ip=$(/sbin/ifconfig $interfaceName | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo "$ip"
#Downloading main group options
echo "Removing machine from system"
cd
rm -rf $defaultRepo
git clone https://AskLab:student123@github.com/AskLab/Default.git $defaultRepo
cp -f $defaultRepo/interfaces /etc/network/

ifconfig $interfaceName down
/etc/init.d/networking restart
sed -i '/'$ip'/d' $defaultRepo/$addressDatabase

#Saving latest address Database
cd $defaultRepo
git add $addressDatabase
git commit -m "$var"
git push -u origin master

#Deleting branch of this machine
cd $repo
git push origin --delete $var

rm -rf $defaultRepo
rm -rf $repo
