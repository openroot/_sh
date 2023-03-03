#!/bin/bash
# Name: _helper.sh
# Purpose: [ module ] helper bash script
# --------------------------------------

# region function

_fs_autooperation_auto=0; # default auto-operation is disabled
_fs_autooperation_delayinsec=1; # default delay value in seconds(s)
_fs_autooperation_freshscreen="y"; # default value is not fresh screen

# function to configure auto-operation
function _fs._autooperation () {
	if [[ $_fs_autooperation_auto == 0 ]]; # entering in auto-operation first time
	then
		_fs_autooperation_auto=1;
		echo;
		echo -e "\tEnter delay in second(s) for auto operation: ";
		read _fs_autooperation_delayinsec;
		echo -e "\tEnter [any key] for fresh screen ;[n] for default screen: ";
		read _fs_autooperation_freshscreen;
	fi
}

function _fs._datetime () {
	local _now=`date +"%d-%m-%Y %R:%S, %A"`;
	echo "$_now";
}

# endregion
