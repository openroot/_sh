#!/bin/bash
# Name: _sh.sh
# Purpose: Menu based App selector bash script
# --------------------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);

# GUI dialog box library
source $_const_currentdir/_dialogbox/_library.sh;

# regionend

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _construct() {
	_arg1=$1;

	_app;
}

function _app() {
	local _filelist=`cd $_const_currentdir | ls`;
# 	printf "$_filelist\n";

	# possible space separated list of app name available (in current directory)
	local _oifs=$IFS;
	IFS=$'\n';
	local _directoriesandfiles=($_filelist);
	IFS=$_oifs;
# 	echo "${_directoriesandfiles[@]}";

	local _index=0;
	local _menustring="";
	local _apps=();
	# generating array of apps
	for _possibleapp in "${_directoriesandfiles[@]}";
	do
		case "$_possibleapp" in
		"_sh.sh"|"_temporary_container")
			;;
		*)
			local _app=$_possibleapp;
			_apps+=($_app);
			let _index=$_index+1;
			_menustring="$_menustring$_index $_app ";
# 			printf "App Name: $_index $_app\n";
			;;
		esac
	done
#  	printf "$_menustring";

	local _selectionorder=-1;

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
		--menu "Choose an App to Execute" 13 28 25 $_menustring 2> "$_const_currentdir/_temporary_container/output.txt";

		local _menustatus=$?;
		_selectionorder=`cat $_const_currentdir/_temporary_container/output.txt`;

		if [[ $_menustatus != 0 ]];
		then
			_selectionorder=-1;
		fi
	fi

	# trying executing selected app (if any successfully selected)
	if [[ $_selectionorder != -1 ]];
	then
		cd ${_apps[$_selectionorder-1]};
		./${_apps[$_selectionorder-1]}.sh;
	fi
}

# endregion

# region input

_construct $1;

# endregion
