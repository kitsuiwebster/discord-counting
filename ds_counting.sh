#!/bin/bash

# The purpose of this script is to automate the counting (Discord bot) on a Discord server, with 2 Discord accounts
#
# - The script sends 1501 times messages and then stops
# - You may need to reboot your computer if your log screen get locked while the script is still running 
#
# To make the script work well:
#
# - You first need to have 2 Discord accounts and need to be logged in both of your pages
# - Prepare both of your Discord couting pages (Discord client + Discord on any browser)
# - Once you run the script go on the first Discord page, where your need to type the first number
# - Make sure that the second Discord page is directly accessible with alt+tab
# - Press Ctrl+C in the console to stop it

set --exit-on-error --errtrace

trap 'clean' SIGINT SIGTERM

clean() {
	if [ "${pidList}X" != "X" ] ; then
		for pid in ${pidList} ; do
			kill -9 ${pid}
		done
	fi
	pkill screenkey
	exit 2
}

# Set the keyboard map
setxkbmap ${keyboardMap}

# xdotool is necessary to automate actions
sudo apt-get install --yes xdotool

# screenkey to display the inputs
sudo apt-get install --yes screenkey
screenkey &
pidList="${pidList} $!"
sleep 20

# Change the number variable as the number you want the script to start from
number=1
echo "The script has started."

# The loop iterates 1501 times to avoid detections
counter=0

while [ $counter -lt 1500 ]
do
# You can add a comment after the $number with quotes + a space, ex: " hey"
    xdotool type $number
    ((number++))
    sleep 1

    xdotool key KP_Enter
    sleep 3

        xdotool key alt+Tab
    sleep 1

	((counter++))
done

for pidItem in ${pidList}; do
	wait ${pidItem} || let "rc=1"
done

exit ${rc}
