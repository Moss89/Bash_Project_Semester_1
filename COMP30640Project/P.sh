#!/bin/bash

if [ -z "$1" ] ; then
	# Check an arg exists
	echo "Error, no argument found: $0"
	exit 1
	# check if the target exists
elif [ ! -e "$1" ] ; then
	echo "$1"
	echo "Target for the lock must exist"
	exit 2
else
	# create the lock if it doesn't exist, otherwise wait
	while ! ln "$0" "$1.lock" 2>/dev/null; do
		sleep 1
	done
	exit 0
fi
