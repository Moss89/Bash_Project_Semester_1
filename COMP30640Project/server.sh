#!/bin/bash
# create server pipe
mkfifo server.pipe

while true; do
trap ctrl_c INT

#trap ctrl+c to remove pipe
function ctrl_c(){
rm server.pipe
exit 0
}
# read from the server pipe
if [ -e server.pipe ]; then
read message < server.pipe

# retrieve args
id="$(cut -d' ' -f2 <<< "$message")"
command="$(cut -d' ' -f5 <<< "$message")"
db="$(cut -d' ' -f6 <<< "$message")"

# process commands based on input
case "$command" in
	"create_database")
        ./create_database.sh "$db" "$id" &

	;;
	"create_table")	
	table="$(cut -d' ' -f7 <<< "$message")"
	columns="$(cut -d' ' -f8 <<< "$message")"
	./create_table.sh "$id" "$db" "$table" "$columns" &
	;;

	"insert")
	table="$(cut -d' ' -f7 <<< "$message")"
	columns="$(cut -d' ' -f8 <<< "$message")"
	./insert.sh "$db" "$table" "$columns" "$id" &
	;;

	"select")
	table="$(cut -d' ' -f7 <<< "$message")"
	columns="$(cut -d' ' -f8 <<< "$message")"
	./select.sh "$id" "$db" "$table" "$columns" &
	;;

	# shutdown the server and remove pipe
	"shutdown")
	echo "Shutting down server...." > "$id.pipe"
	rm "server.pipe"
	exit 0
	;;

	*)
	# error if command is invalid
	echo "Error: bad request" > "$id.pipe"
	exit 1
	;;
esac
fi
done
 

