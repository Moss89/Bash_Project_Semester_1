#!/bin/bash
if [ -z $@ ] ; then
	# check for arg
	echo "Error: No ID given"
	exit 1
else
	# make pipe
	mkfifo $1.pipe
	mypipe="$1.pipe"
	trap ctrl_c INT
	# trap ctrl+c and delete client pipe
	function ctrl_c(){
	rm "$mypipe" 
	exit 0
	}
	# infinite loop 	
	while [ True ]; do
		read input
		# extract command and db
		cmd="$(cut -d' ' -f1 <<< "$input")"
		db="$(cut -d' ' -f2 <<< "$input")"
		
		if [ $cmd = "create_database" ] ; then 
		# send args to server	
		echo "ID: $1 with command $cmd $db" > server.pipe
		# read response from script
		read status < $mypipe
		echo "$status"		

		elif [ $cmd = "create_table" ] ; then
		table="$(cut -d' ' -f3 <<< "$input")"
		columns="$(cut -d' ' -f4 <<< "$input")"
		echo "ID: $1 with command $cmd $db $table $columns" > server.pipe 
		read status < $mypipe
		echo "$status"		

		elif [ $cmd = "insert" ] ; then
		table="$(cut -d' ' -f3 <<< "$input")"
		columns="$(cut -d' ' -f4 <<< "$input")"
		echo "ID: $1 with command $cmd $db $table $columns" > server.pipe
		read status < $mypipe	
		echo "$status"	
	
		elif [ $cmd = "select" ] ; then
		table="$(cut -d' ' -f3 <<< "$input")"
		columns="$(cut -d' ' -f4 <<< "$input")"
		echo "ID: $1 with command $cmd $db $table $columns" > server.pipe
		read status < $mypipe
		statusNewLine=$(echo $status | sed "s/ /\n/g")
		echo "$statusNewLine"	
	
		elif [ $cmd = "shutdown" ] ; then
		# shutdown server
		echo "ID: $1 with command $cmd" > server.pipe
		read exitcode < $mypipe
		echo "$exitcode"
		
		elif [ $cmd = "exit" ] ; then
		# exit client
		echo "Exiting the client..."
		# remove pipe
		rm "$mypipe"
		exit 0
	
		else	
		# error for incorrect input
			echo "Error: incorrect input"
		fi
		done
fi
