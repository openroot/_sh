#!/bin/bash
# Name: _sh.sh
# Purpose: Menu based App selector bash script
# --------------------------------------------

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

function _appmenugen() {
	local _arg1=$1;

	# possible space separated list of app name available (in current directory)
	_directoriesandfile="_coffee _d2h _multichoice _quote _sh.sh _sl temporary_container _wc";
	IFS=' ';
	read -ra _directoriesandfiles <<< "$_directoriesandfile";

	_index=0;
	_menustring="";
	_apps=();
	# generating array of apps
	for _possibleapp in "${_directoriesandfiles[@]}";
	do
		case "$_possibleapp" in
		_sh.sh|temporary_container)
			;;
		*)
			_app=$_possibleapp;
			_apps+=($_app);
			let _index=$_index+1;
			_menustring="$_menustring$_index $_app ";
# 			printf "App Name: $_index $_app\n";
			;;
		esac
	done
# 	printf "$_menustring";

	_selectionorder=-1;

	# trying taking app selection from passed argument from console
	if ! [ -z $_arg1 ]
	then
		_index=1;
		for _app in "${_apps[@]}";
		do
			if [[ $_app == *"$_arg1"* ]];
			then
# 				printf "Found App: $_index $_app\n";
				_selectionorder=$_index;
			fi
			let _index=$_index+1;
		done
	fi

	# trying taking app selection from dialog menu
	if [[ $_selectionorder == -1 ]];
	then
		dialog --clear --erase-on-exit \
		--title "App list" \
		--menu "Choose an App to Execute" 13 28 25 $_menustring 2> "temporary_container/output.txt";

		_menustatus=$?;
		_selectionorder=`cat temporary_container/output.txt`;

		if [[ $_menustatus != 0 ]];
		then
			_selectionorder=-1;
		fi
	fi

	# trying executing selected app (if any successfully selected)
	if [[ $_selectionorder != -1 ]];
	then
		_selectedapp="${_apps[$_selectionorder-1]}/${_apps[$_selectionorder-1]}.sh";
# 		printf "Selected App: $_selectedapp\n";
#  		echo "${_apps[@]}";
		./$_selectedapp;
	fi
}

# endregion

# region input

_arg1=$1;
_appmenugen $_arg1;

# endregion
