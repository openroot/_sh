#!/bin/bash
# Name: _wc.sh
# Purpose: Word Count bash script
# -------------------------------

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _wc() {
	eval _string="$1";

	#echo $_string;

	# Counting words
	_word=$(echo -n "${_string}" | wc -w);
	# Counting characters
	_char=$(echo -n "${_string}" | wc -c);

	# Counting Number of white spaces (Here,specificly " ")
	# sed "s/ change this to whitespace//g"
	_space=$(expr length "${_string}" - length `echo "${_string}" | sed "s/ //g"`);

	# Counting special characters
	_special=$(expr length "${_string//[^\~!@#$&*()]/}");

	# Output
	echo "Number of Words = $_word";
	echo "Number of Characters = $_char";
	echo "Number of White Spaces = $_space";
	echo "Number of Special symbols = $_special";
}

# endregion

# region input

_arg1=$1;

# endregion

# region execute

if [[ -z "$_arg1" ]]
then
	read -rp "Enter a string: " "_string";
	_wc "\${_string}";
else
	_wc "\${_arg1}";
fi

# endregion
