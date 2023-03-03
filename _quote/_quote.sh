#!/bin/bash
# Name: _quote.sh
# Purpose: Quote bash script
# --------------------------

# region input

read -rp "Enter quote: " "_quote";
read -rp "Enter time (in seconds): " "_time";
read -rp "Enter number of loops: " "_loopcount";
echo;

# endregion

# region execute

_a=0;
while [[ $_a -lt $_loopcount ]]
do
	let _a=$_a+1;

	echo "༂࿐~~ $_quote :[$_a]";

	sleep $_time;
done

# endregion
