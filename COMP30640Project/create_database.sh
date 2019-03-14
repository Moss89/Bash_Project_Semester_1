#!/bin/bash
if [ $# -ne 2 ] ; then
	# Check if args = 2, if not, error
	echo "Error: One parameter is required" > "$2.pipe" 
	exit 1

elif [ -d $1 ] ; then
	# Check if db already exists, if so, error
	echo "Error: The database already exists" > "$2.pipe"
	exit 2
else
	# Add lock on script process
	./P.sh $0
	# Make directory
	mkdir /home/tomas/COMP30640Project/$1
	# Remove lock
	./V.sh $0
	# output results to client pipe
	echo "start_result Database created end_result" > "$2.pipe"
	exit 0
fi
