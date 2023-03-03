#!/bin/bash
# Name: _sl.sh
# Purpose: sl bash script
# -----------------------

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _sl() {
	local _arg1=$1;
	if [[ $_arg1 == "b" ]];
	then
		echo sl;
	else
		echo sl -l;
	fi
}

# endregion

# region input

_arg1=$1;
read -rp "Press / <any key> for [infinite] / <l/L> for [loop]: " "_choice";

# endregion

# region execute

if [[ $_choice == "l" || $_choice == "L" ]];
then
	read -rp "Put loop count: " "_loopcount"; echo;
	_a=0;
	while [[ $_a -lt $_loopcount ]]
	do
		let _a=$_a+1;
		`_sl $_arg1`;
	done
else
	while : ; do
		`_sl $_arg1`;
	done
fi

# endregion
