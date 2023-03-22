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
	# loop infinite for app(s) menu
	while true;
	do
		local _filelist=`cd $_const_currentdir | ls`;
		#_dialog._message "$_filelist";

		# possible space separated list of app name available (in current directory)
		_dialog._newlinedelimitedstringtoarray "$_filelist";
		_directoriesandfiles=("${_dialog_array[@]}");
		#_dialog._message "${_directoriesandfiles[@]}";

		local _apps=();
		local _index=0;
		local _menustring="";
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
				_menustring="$_menustring$_index;$_app;";
				#_dialog._message "App Name: $_index $_app";
				;;
			esac
		done
		#printf "$_menustring";

		local _selectionorder=-1;

		# trying taking app selection from passed argument from console
		if ! [ -z $_arg1 ]
		then
			_index=1;
			for _app in "${_apps[@]}";
			do
				if [[ $_app == *"$_arg1"* ]];
				then
					#_dialog._message "Found App: $_index $_app";
					_selectionorder=$_index;
				fi
				let _index=$_index+1;
			done
		fi

		# trying taking app selection from dialog menu
		if [[ $_selectionorder == -1 ]];
		then
			_dialog._menu "$_menustring" "Choose an App to Execute" "App list" "13" "28" "25";
			if [[ $_dialog_menu_result != -1 ]];
			then
				_selectionorder=$_dialog_menu_result;
			fi
		fi

		# trying executing selected app (if any successfully selected)
		if [[ $_selectionorder != -1 ]];
		then
			cd ${_apps[$_selectionorder-1]};
			./${_apps[$_selectionorder-1]}.sh;
			cd ..;
		else
			break;
		fi
	done
}

# endregion

# region input

_construct $1;

# endregion
