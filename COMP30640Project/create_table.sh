#!/bin/bash
database="$2"
table="$3"
columns="$4"
	
# Check there are 4 parameters (3 from user as one is Id given by the client), or that columns aren't empty. If not, error 
if [ $# -ne 4 ] || [ -z $columns ] ; then
	
	echo "start_result Error: There should be 3 parameters end_result" > "$1.pipe"
	exit 1

# Check that the database doesn't already exist, if it does, error
elif [ ! -d $database ] ; then
 
	echo "start_result Error: The database doesn't exist end_result" >  "$1.pipe"
        exit 2

# Check if the table already exists, if it does, error
elif [[ -e ~/COMP30640Project/$database/$table ]] ; then
	echo "start_result Error: The table already exists end_result" > "$1.pipe"
	exit 3
else	
	# Set lock
	./P.sh "$0"
	# Create file
	touch ~/COMP30640Project/$database/$table
	# Add column names
	echo $columns >> ~/COMP30640Project/$database/$table
	# Output to pipe
	echo "start_result $table created end_result" > "$1.pipe"
	# Remove lock
	./V.sh "$0"
	exit 0 
fi

