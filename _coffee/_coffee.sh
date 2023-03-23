#!/bin/bash
# Name: _coffee.sh
# Purpose: Fake Install for coffee time bash script
# -------------------------------------------------

# region function

_iscoffeefinish=-1;
trap _coffee._trap SIGQUIT;

function _coffee._trap() {
	# press Ctrl+\ to stop app
	_iscoffeefinish=1;
}

function _coffee._fake() {
	_i=0;
	while true;
	do
		let _i=$_i+1;
		{
			for _j in $(seq 0 1 100);
			do
				printf "$_j\n";
				sleep .01;
			done 
		} | dialog --gauge "Install Part $_i : `sed $(perl -e "print int rand(99999)")"q; d" /usr/share/dict/words`" 6 40;

		if [[ $_iscoffeefinish == 1 ]];
		then
			break;
		fi
	done
}

# endregion

# region execute

_coffee._fake;

# endregion
