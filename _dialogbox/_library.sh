 #!/bin/bash
# Name: _library.sh
# Purpose: GUI DialogBox library bash script
# ------------------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);

# regionend

# region function

function _dialog._message() {
	local _message="$1";
	local _title=$2;
	local _height=9;
	local _width=32;
	if ! [ -z $3 ]
	then
		_height=$3;
	fi
	if ! [ -z $4 ]
	then
		_width=$4;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--msgbox "$_message" \
	$_height $_width;
}

function _dialog._menu() {
	local _items=$1;
	local _menumessage=$2;
	local _title=$3;
	local _height=13;
	local _width=28;
	local _menuheight=25;

	# converting semicolon separated list of menu items into array
	local _oifs=$IFS;
	IFS=$';';
	_items=($_items);
	IFS=$_oifs;
# 	echo "${_items[@]}";

	if ! [ -z $4 ]
	then
		_height=$4;
	fi
	if ! [ -z $5 ]
	then
		_width=$5;
	fi
	if ! [ -z $6 ]
	then
		_menuheight=$6;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--menu "$_menumessage" \
	$_height $_width $_menuheight \
	"${_items[@]}" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _menustatus=$?;
	_dialog_menu_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;
#
	if [[ $_menustatus != 0 ]];
	then
		_dialog_menu_result=-1;
	fi
}

# endregion
