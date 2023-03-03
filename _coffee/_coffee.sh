#!/bin/bash
# Name: _coffee.sh
# Purpose: Fake Install for coffee time bash script
# -------------------------------------------------

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _fake() {
	_i=0;
	while true;
	do
		let _i=$_i+1;
		for _j in $(seq 0 1 100);
		do
			echo $_j;
			sleep .01;
		done |
		dialog --gauge "Install Part $_i : `sed $(perl -e "print int rand(99999)")"q; d" /usr/share/dict/words`" 6 40;
	done
}

# endregion

# region execute

_fake;

# endregion
