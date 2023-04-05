#!/bin/bash

# @name: Discord couting script
# @author: Kitsui#8258

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

# The loop iterates 1000 times to avoid detections
counter=0

echo "The script has started."

while [ $counter -lt 1000 ]
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
