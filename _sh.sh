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
		# getting default separated files and directories list
		local _list=`cd $_const_currentdir | ls`;
		#_dialog._message "$_list";

		# possible default separated list of app name available (in current directory relative)
		_dialog._newlinedelimitedstringtoarray "$_list";
		_directoriesandfiles=("${_dialog_array[@]}");



		# filtering out valid apps into another array
		local _apps=();
		for _possibleapp in "${_directoriesandfiles[@]}";
		do
			case "$_possibleapp" in
			"_sh.sh"|"_temporary_container")
				;;
			*)
				_apps+=($_possibleapp);
				;;
			esac
		done



		# try taking app selection from either console argument or on failure from dialogbox
		local _selectedtag=-1;

		# trying taking app selection from console argument
		if ! [ -z $_arg1 ]
		then
			local _index=1;
			for _app in "${_apps[@]}";
			do
				if [[ $_app == *"$_arg1"* ]];
				then
					_selectedtag=$_index;
					#_dialog._message "$_index $_app" "Found App";
					break;
				fi
				let _index=$_index+1;
			done
		fi

		# trying taking app selection from dialog menu
		if [[ $_selectedtag == -1 ]];
		then
			_dialog._menu._labelgenerator "${_apps[@]}";
			local _menuitemslabels=$_dialog_menu_labels;

			_dialog._menu "$_menuitemslabels" "Choose an App to Execute" "App list" "14" "34" "10";
			if [[ $_dialog_menu_result != -1 ]];
			then
				_selectedtag=$_dialog_menu_result;
			fi
		fi



		# trying executing selected app (if any successfully selected)
		if [[ $_selectedtag != -1 ]];
		then
			cd ${_apps[$_selectedtag-1]};
			./${_apps[$_selectedtag-1]}.sh;
			cd ..;
		else
			break;
		fi



		# after first run (possible) from console argument empty console argument to show default dialogbox
		_arg1="";
	done
}

# endregion

# region input

_construct $1;

# endregion
