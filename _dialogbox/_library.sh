 #!/bin/bash
# Name: _library.sh
# Purpose: GUI Dialogbox library bash script
# ------------------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);

# regionend

# region function

function _dialog._construct() {
	# create directory "_temporary_container" at 'source caller' directory if not already exists
	_temporarycontainerdirectoryname="_temporary_container";
	if ! [ -d "$_temporarycontainerdirectoryname" ];
	then
		mkdir $(printf "$_temporarycontainerdirectoryname";);
	fi
}

function _dialog._chardelimitedstringtoarray() {
	local _chardelimitedstring=$1;
	local _chardelimiter=";";

	if ! [ -z $2 ]
	then
		_chardelimiter=$2;
	fi

	# converting char delimited string into array
	local _oifs=$IFS;
	IFS=$"$_chardelimiter";
	_dialog_array=($_chardelimitedstring);
	IFS=$_oifs;
}

function _dialog._newlinedelimitedstringtoarray() {
	local _newlinedelimitedstring=$1;

	# converting newline delimited string into array
	local _oifs=$IFS;
	IFS=$'\n';
	_dialog_array=($_newlinedelimitedstring);
	IFS=$_oifs;
}

function _dialog._tabdelimitedstringtoarray() {
	local _tabdelimitedstring=$1;

	# converting tab delimited string into array
	local _oifs=$IFS;
	IFS=$'\t';
	_dialog_array=($_tabdelimitedstring);
	IFS=$_oifs;
}

function _dialog._getvaluefromdoubledimensionarray() {
	local _items=$1;
	local _row=$2;
	local _column=$3;
	local _arraygrouplength=$4;

	# converting semicolon separated list of items into array
	_dialog._chardelimitedstringtoarray "$_items";
	_items=("${_dialog_array[@]}");

	_dialog_valuefromdoubledimensionarray=${_items[$(((($_row-1)*$_arraygrouplength)+($_column-1)))]};
}

function _dialog._menu._labelgenerator() {
	local _rawlabels=("$@");

	# generating numerical ordered labels from array
	_dialog_menu_labels="";
	local _rawlabelscount=${#_rawlabels[@]};
	if [[ $_rawlabelscount > 0 ]];
	then
		for _i in $(seq 0 1 $((_rawlabelscount-1)));
		do
			_dialog_menu_labels="$_dialog_menu_labels$((_i+1));${_rawlabels[$_i]};";
		done
	fi
}

function _dialog._checklist._labelgenerator() {
	local _rawlabels=("$@");

	# generating numerical ordered labels from array
	_dialog_checklist_labels="";
	local _rawlabelscount=${#_rawlabels[@]};
	if [[ $((_rawlabelscount%2)) == 0 ]];
	then
		for _i in $(seq 0 2 $((_rawlabelscount-1)));
		do
			_dialog_checklist_labels="$_dialog_checklist_labels$(((_i/2)+1));${_rawlabels[$_i]};${_rawlabels[$((_i+1))]};";
		done
	fi
}

function _dialog._checklist._getlabelbytag() {
	local _items=$1;
	local _tag=$2;
	local _arraygrouplength=3;
	local _column=2;

	_dialog._getvaluefromdoubledimensionarray "$_items" "$_tag" "$_column" "$_arraygrouplength";
	_dialog_checklist_labelbytag=$_dialog_valuefromdoubledimensionarray;
}

function _dialog._radiolist._labelgenerator() {
	local _rawlabels=("$@");
	
	_dialog._checklist._labelgenerator "${_rawlabels[@]}";
	_dialog_radiolist_labels=$_dialog_checklist_labels;
}

function _dialog._radiolist._getlabelbytag() {
	local _items=$1;
	local _tag=$2;

	_dialog._checklist._getlabelbytag "$_items" "$_tag";
	_dialog_radiolist_labelbytag=$_dialog_checklist_labelbytag;
}

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

	# converting semicolon separated list of items into array
	_dialog._chardelimitedstringtoarray "$_items";
	_items=("${_dialog_array[@]}");
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

function _dialog._form() {
	local _items=$1;
	local _formmessage=$2;
	local _title=$3;
	local _height=11;
	local _width=34;
	local _formheight=3;

	# converting semicolon separated list of items into array
	_dialog._chardelimitedstringtoarray "$_items";
	_items=("${_dialog_array[@]}");
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

	# converting semicolon separated list of items into array
	_dialog._chardelimitedstringtoarray "$_items";
	_items=("${_dialog_array[@]}");
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

function _dialog._checklist() {
	local _items=$1;
	local _checklistmessage=$2;
	local _title=$3;
	local _height=11;
	local _width=34;
	local _checklistheight=3;

	# converting semicolon separated list of items into array
	_dialog._chardelimitedstringtoarray "$_items";
	_items=("${_dialog_array[@]}");
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
		_checklistheight=$6;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--checklist "$_checklistmessage" \
	$_height $_width $_checklistheight \
	"${_items[@]}" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _checkliststatus=$?;
	_dialog_checklist_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_checkliststatus != 0 ]];
	then
		_dialog_checklist_result=-1;
	else
		# converting space separated tag list to ; separated list
		_dialog_checklist_result=$(printf "$_dialog_checklist_result" | tr " " "\n";);
	fi
}

function _dialog._radiolist() {
	local _items=$1;
	local _radiolistmessage=$2;
	local _title=$3;
	local _height=11;
	local _width=34;
	local _radiolistheight=3;

	# converting semicolon separated list of items into array
	_dialog._chardelimitedstringtoarray "$_items";
	_items=("${_dialog_array[@]}");
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
		_radiolistheight=$6;
	fi

	dialog --clear --erase-on-exit \
	--title "$_title" \
	--radiolist "$_radiolistmessage" \
	$_height $_width $_radiolistheight \
	"${_items[@]}" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _radioliststatus=$?;
	_dialog_radiolist_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_radioliststatus != 0 ]];
	then
		_dialog_radiolist_result=-1;
	fi
}

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

function _dialog._fselect() {
	local _filepath="";
	local _title="";
	local _height=4;
	local _width=40;
	
	if ! [ -z $1 ]
	then
		_filepath=$1;
	fi
	if ! [ -z $2 ]
	then
		_title=$2;
	fi
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
	--fselect "$_filepath" \
	"$_height" "$_width" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _fselectstatus=$?;
	_dialog_fselect_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_fselectstatus != 0 ]];
	then
		_dialog_fselect_result=-1;
	fi;
}

function _dialog._textbox() {
	local _filepath="";
	local _title="";
	local _height=14;
	local _width=64;
	
	if ! [ -z $1 ]
	then
		_filepath=$1;
	fi
	if ! [ -z $2 ]
	then
		_title=$2;
	fi
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
	--textbox "$_filepath" \
	"$_height" "$_width";

	_dialog_textbox_result=$?;
}

function _dialog._editbox() {
	local _filepath="";
	local _title="";
	local _height=14;
	local _width=64;
	
	if ! [ -z $1 ]
	then
		_filepath=$1;
	fi
	if ! [ -z $2 ]
	then
		_title=$2;
	fi
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
	--editbox "$_filepath" \
	"$_height" "$_width" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _editboxstatus=$?;
	_dialog_editbox_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_editboxstatus != 0 ]];
	then
		_dialog_editbox_result=-1;
	fi
}

function _dialog._timebox() {
	local _hour=$1;		# set 'null or empty' to value as 0
	local _minute=$2;	# set 'null or empty' to value as 0
	local _second=$3;	# set 'null or empty' to value as 0
	local _timeboxmessage=$4;
	local _title=$5;
	local _height=2;
	local _width=34;

	if ! [ -z $6 ]
	then
		$_height=$6;
	fi
	if ! [ -z $7 ]
	then
		$_width=$7;
	fi
	
	dialog --clear --erase-on-exit \
	--title "$_title" \
	--timebox "$_timeboxmessage" \
	"$_height" "$_width" \
	"$_hour" "$_minute" "$_second" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _timeboxstatus=$?;
	_dialog_timebox_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_timeboxstatus != 0 ]];
	then
		_dialog_timebox_result=-1;
	fi
}

function _dialog._calendar() {
	local _date=$1;		# set 'null or empty' to current value
	local _month=$2;	# set 'null or empty' to current value
	local _year=$3;		# set 'null or empty' to current value
	local _calendarmessage=$4;
	local _title=$5;
	local _height=3;
	local _width=38;

	if ! [ -z $6 ]
	then
		$_height=$6;
	fi
	if ! [ -z $7 ]
	then
		$_width=$7;
	fi
	
	dialog --clear --erase-on-exit \
	--title "$_title" \
	--calendar "$_calendarmessage" \
	"$_height" "$_width" \
	"$_date" "$_month" "$_year" 2> "${_const_currentdir}/_temporary_container/output.txt";

	local _calendarstatus=$?;
	_dialog_calendar_result=`cat ${_const_currentdir}/_temporary_container/output.txt`;

	if [[ $_calendarstatus != 0 ]];
	then
		_dialog_calendar_result=-1;
	fi
}

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

# region execute

_dialog._construct;

# regionend