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
	local _message=$1;
	local _title=$2;
	local _height=9;
	local _width=34;
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
	local _height=11;
	local _width=34;
	local _menuheight=3;

	# converting semicolon separated list of menu items into array
	local _oifs=$IFS; IFS=$';'; _items=($_items); IFS=$_oifs;
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

	if [[ $_menustatus != 0 ]];
	then
		_dialog_menu_result=-1;
	fi
}

function _dialog._menu._labelgeneratorfromarray() {
	local _rawmenulabels=("$@");
	local _index=0;
	_dialog_menu_numericalorderedlabels="";

	# generating numerical ordered menu labels from array
	for _menulabel in "${_rawmenulabels[@]}";
	do
		let _index=$_index+1;
		_dialog_menu_numericalorderedlabels="$_dialog_menu_numericalorderedlabels$_index;$_menulabel;";
	done
}

function _dialog._form() {
	local _items=$1;
	local _formmessage=$2;
	local _title=$3;
	local _height=11;
	local _width=34;
	local _formheight=3;

	# converting semicolon separated list of form items into array
	local _oifs=$IFS; IFS=$';'; _items=($_items); IFS=$_oifs;
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
		_formheight=$6;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--form "$_formmessage" \
	$_height $_width $_formheight \
	"${_items[@]}" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _formstatus=$?;
	_dialog_form_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_formstatus != 0 ]];
	then
		_dialog_form_result=-1;
	fi
}

function _dialog._mixedform() {
	local _items=$1;
	local _mixedformmessage=$2;
	local _title=$3;
	local _height=11;
	local _width=34;
	local _mixedformheight=3;

	# converting semicolon separated list of form items into array
	local _oifs=$IFS; IFS=$';'; _items=($_items); IFS=$_oifs;
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
		_mixedformheight=$6;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--mixedform "$_mixedformmessage" \
	$_height $_width $_mixedformheight \
	"${_items[@]}" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _mixedformstatus=$?;
	_dialog_mixedform_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_mixedformstatus != 0 ]];
	then
		_dialog_mixedform_result=-1;
	fi
}

function _dialog._inputbox() {
	local _init=$1;
	local _inputboxmessage=$2;
	local _title=$3;
	local _height=8; # "8" is minimum convenient height possible
	local _width=34;

	if ! [ -z $4 ]
	then
		_height=$4;
	fi
	if ! [ -z $5 ]
	then
		_width=$5;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--inputbox "$_inputboxmessage" \
	$_height $_width \
	"$_init" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _inputboxstatus=$?;
	_dialog_inputbox_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_inputboxstatus != 0 ]];
	then
		_dialog_inputbox_result=-1;
	fi
}

# function _dialog._checklist() {
# }

# function _dialog._radiolist() {
# }

function _dialog._yesno() {
	local _yesnomessage=$1;
	local _title=$2;
	local _height=9;
	local _width=34;

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
	--yesno "$_yesnomessage" \
	$_height $_width;
	_dialog_yesno_result=$?;
}

# function _dialog._gauge() {
# }

# function _dialog._progressbox() {
# }

# function _dialog._rangebox() {
# }

# function _dialog._buildlist() {
# }

# function _dialog._treeview() {
# }

# function _dialog._fselect() {
# }

# function _dialog._textbox() {
# }

# function _dialog._editbox() {
# }

# function _dialog._timebox() {
# }

# function _dialog._calender() {
# }

function _dialog._prgbox() {
	local _command=$1;
	local _prgboxmessage=$2;
	local _title=$3;
	local _height=9;
	local _width=34;

	if ! [ -z $4 ]
	then
		_height=$4;
	fi
	if ! [ -z $5 ]
	then
		_width=$5;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--prgbox "$_prgboxmessage" "$_command" \
	$_height $_width;
}

# endregion
