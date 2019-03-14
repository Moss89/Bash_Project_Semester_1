#!/bin/bash
database=$2
table=$3
columns=$4


if [ $# -lt 3 ] ; then
	# check for at least 3 args
	echo "start_result Error: There should be at least 2 parameters end_result" > "$1.pipe"
	exit 1

elif [[ ! -e ~/COMP30640Project/$database/$table ]] ; then
	# check db/table exist
	echo "start_result The database and/or table don't exist! end_result" > "$1.pipe"
	exit 2
fi
	# Get table columns
tablecols=$(head -n 1 ~/COMP30640Project/$database/$table)
	# Count the number of table columns
tablecolnum=(`echo "$tablecols" | sed 's/,/\ /g' | wc -w`)

	# Check for numbers or no column input
if echo "$columns" | grep "[0-9]" || [ -z $columns ] ; then
 	# Find the largest and lowest column number 
	columnmax=(`echo "$4" |sed 's/,/\n/g' | sort -n | tail -n1`)
	columnmin=(`echo "$4" | sed 's/,/\n/g' | sort -n | head -n1`)

	# check the numbers entered aren't higher than the table column amount
	if [[ "$columnmax" -gt "$tablecolnum" ]] ; then
	echo "start_result There aren't that many columns in the table! end_result"  "$1.pipe"
	exit 3
	
	# check that 0 isn't entered
	elif [ "$columnmin" == 0 ] ; then
	echo "start_result Must start at column number 1 end_result" > "$1.pipe"
	exit 4
	
	# Check for blank column args
	elif [ -z "$columns" ] ; then
	# add lock
	./P.sh "$database/$table"
	# output everything in the file with newlines changed to spaces 
	output="$(cat ~/COMP30640Project/$database/$table)"
	outputline=$(echo $output | sed "s/\n/ /g")
	echo "start_result $outputline end_result" > "$1.pipe" 
	# remove lock
	./V.sh "$database/$table"
	exit 0
	
	else
	# add lock
	./P.sh "$database/$table"
	# out the selected columns with newlines changed to spaces
	output="$(cut -d"," -f"$columns" ~/COMP30640Project/$database/$table)"
	outputline=$(echo $output | sed "s/\n/ /g")
	echo "start_result $outputline end_result" > "$1.pipe"
	# remove lock
	./V.sh "$database/$table"
	exit 0
	fi
else
	nameColumns=""
	# Iterate through the user input, replacing commas with spaces
	for i in `echo "$columns" | sed "s/,/ /g"`; do
	# check if the input is in the table
	if [[ $tablecols = *$i* ]]; then
	# get the column name field from the table where it matches the user input
	numberColumn=$(head -1 ~/COMP30640Project/$database/$table | sed "s/,/\n/g" | grep -n "$i" | cut -d":" -f 1 | sed "s/ //g")  
	# append it and add a space
	nameColumns+="$numberColumn "
	else
		# error if input not found
		echo "start_result The column wasn't found! end_result" > "$1.pipe"
	exit 5
	fi
	done
	# replace the spaces with commas and last line comma with blank
	columnResult=$(echo "$nameColumns" | sed "s/ /,/g" | sed "s/,$//g")
	# add lock
	./P.sh "$database/$table"
	# output with newlines replaced with spaces
	output="$(cut -d"," -f"$columnResult" ~/COMP30640Project/$database/$table)"
	outputline=$(echo $output | sed "s/\n/ /g")
	echo "start_result $outputline end_result" > "$1.pipe"
	# remove lock
	./V.sh "$database/$table"
	exit 0
fi
