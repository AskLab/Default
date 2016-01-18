#!/bin/bash
mac=$(cat /sys/class/net/eth0/address)
var=${mac//:}
currentTime=$(date +"%m-%d-%y_%H%M")

#Copy current options to repo
cp -f /etc/network/interfaces $repo
cd /home/root/usr/AskRepo/

#Check for changes and do action
output=$(git status)
if [[ $output == *"interfaces"* ]]
then
	git checkout -b var
	git add interfaces
	git commit -m "$currentTime"
	git push -u origin $var
	echo "Updated new options on branch: $var with commit message: $currenttTime"
else
	echo "Options up to date"
fi