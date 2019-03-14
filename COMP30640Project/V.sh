#!/bin/bash

if [ -z "$1" ] ; then
	# check the arg exists
	echo "Error: missing argument: $1"
	exit 1
else	
	# remove the lock
	rm "$1.lock"
	exit 0
fi
