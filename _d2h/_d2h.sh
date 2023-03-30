#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing bash script
# --------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);
# parent directory (relative)
_const_parentdir=$(builtin cd ..; pwd);

# dialogbox library
source $_const_parentdir/_dialogbox/_library.sh;

# regionend

# region function

trap _d2h._trap SIGINT;
function _d2h._trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _d2h._construct() {
	_arg1=$1;

	_d2h_channels_db_file="$_const_currentdir/packs/channel-list.txt";
	_d2h_channels_db_rows=();
	_d2h_channels_db_rowcount=-1;
	_d2h_channels_db_cells=();
	_d2h_channels_db_cellcount=-1;
	_d2h_channels_db_tablewidth=-1;
	_d2h_channels_db_isvarified=-1;

	_d2h._app;
}

function _d2h._app() {
	# trying taking channel selection from passed argument from console
	if ! [ -z $_arg1 ]
	then
		_dialog._message "$_arg1" "Passed argument";
	fi

	_d2h._db._read;
	_d2h._db._print;

	#_d2h._searchbyname;
}

function _d2h._db._read() {
	if [[ $_d2h_channels_db_rowcount == -1 ]];
	then
		_dialog._newlinedelimitedstringtoarray "$(cat "$_d2h_channels_db_file")";

		_d2h_channels_db_rows=("${_dialog_array[@]}");

		_d2h_channels_db_rowcount=${#_d2h_channels_db_rows[@]};

		for _row in "${_d2h_channels_db_rows[@]}";
		do
			local _rowline=${_row:0:${#_row}-1};	# removing last most char of line

			local _oifs=IFS; IFS='|'; read -r -a _items <<< "$_rowline"; IFS=$_oifs;

			_d2h_channels_db_cells+=("${_items[@]}");
			
			_d2h_channels_db_tablewidth=${#_items[@]};
		done

		_d2h_channels_db_cellcount=${#_d2h_channels_db_cells[@]};
		
		_d2h._db._checksum "${_d2h_channels_db_rows[0]}" "$_d2h_channels_db_rowcount" "$_d2h_channels_db_cellcount";
		_d2h_channels_db_isvarified=$?;
	fi
}

function _d2h._db._checksum() {
	local _firstrow=$1;
	local _db_rowcount=$2;
	local _db_cellcount=$3;

	if ! [ -z $_firstrow ];
	then
		if [[ $_db_rowcount > 0 ]];
		then
			local _rowline=${_firstrow:0:${#_firstrow}-1};	# removing last most char of line

			local _oifs=IFS; IFS='|'; read -r -a _items <<< "$_rowline"; IFS=$_oifs;

			local _firstrow_cellcount=${#_items[@]};

			if [[ $(($_db_rowcount*$_firstrow_cellcount)) == $_db_cellcount ]];
			then
				return "1";
			else
				return "0";
			fi
		fi
	fi
}

function _d2h._db._print() {
	if [[ $_d2h_channels_db_isvarified == 1 ]];
	then
		local _i=1;
		for _cell in "${_d2h_channels_db_cells[@]}";
		do
			printf "$_i: $_cell\n";
			_i=$(($_i+1));
		done
	fi
}

#function _d2h._searchbyname() {
	# local _inputboxinit="";
	# local _inputboxmessage="Please enter a Channel Name (subsequent)";
	# local _inputboxtitle="Search by Channel Name";

	# _dialog._inputbox "$_inputboxinit" "$_inputboxmessage" "$_inputboxtitle" "9" "34";

	# _dialog._message "$_dialog_inputbox_result" "Inputbox returned value";

	
#}

# endregion

# region execute

_d2h._construct "$1";

# endregion
