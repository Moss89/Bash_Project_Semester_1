#!/bin/bash
database=$1
table=$2
tuple=$3
# remove all but the commas from the columns parameter
tuplecommas="${tuple//[^,]}"
# count the commas
tuplelength="${#tuplecommas}"
# remove all but the commas from the column names in the table, and count
tablecolumns=$(head -n 1 ~/COMP30640Project/$database/$table | tr -cd , | wc -c)

if [ $# -ne 4 ] ; then
# check there are 4 parameters
	echo "start_result Error: There should be 3 parameters end_result" > "$4.pipe"
	exit 1

# Check database exists
elif [ ! -d $database ] ; then
	echo "start_result Error: The database doesn't exist end_result" > "$4.pipe"
	exit 2

# Check table exists
elif [[ ! -e ~/COMP30640Project/$database/$table ]] ; then
	echo "start_result Error: The table does not exist end_result" > "$4.pipe"
	exit 3
# check number of columns = number of table columns
elif [[ "$tuplelength" -ne "$tablecolumns" ]] ; then
	echo "Number of values entered does not match the number of columns in the table" > "$4.pipe"
	exit 4

else
	# Add lock
	./P.sh "$database/$table"
	# insert data
	echo "$tuple" >> ~/COMP30640Project/$database/$table 
	# success message to client pipe
	echo "successful insert" > "$4.pipe"
	# remove lock
	./V.sh "$database/$table"
	exit 0
fi
