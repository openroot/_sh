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

	_db_print_rowseparator="\n";
	_db_print_columnseparator=" | ";
	_db_file="";
	_db_rows=();
	_db_rowcount=-1;
	_db_cells=();
	_db_cellcount=-1;
	_db_tablewidth=-1;
	_db_isvarified=-1;

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

	_db._read "$_d2h_channels_db_file";
	_d2h_channels_db_rows=("${_db_rows[@]}");
	_d2h_channels_db_rowcount=$_db_rowcount;
	_d2h_channels_db_cells=("${_db_cells[@]}");
	_d2h_channels_db_cellcount=$_db_cellcount;
	_d2h_channels_db_tablewidth=$_db_tablewidth;
	_d2h_channels_db_isvarified=$_db_isvarified;

	_db._print "1";

	#_d2h._searchbyname;
}

function _db._read() {
	_db_file=$1;

	if [[ $_db_rowcount == -1 ]];
	then
		_dialog._newlinedelimitedstringtoarray "$(cat "$_db_file")";

		_db_rows=("${_dialog_array[@]}");

		_db_rowcount=${#_db_rows[@]};

		for _row in "${_db_rows[@]}";
		do
			local _rowline=${_row:0:${#_row}-1};	# removing last most char of line

			local _oifs=IFS; IFS='|'; read -r -a _items <<< "$_rowline"; IFS=$_oifs;

			_db_cells+=("${_items[@]}");
			
			_db_tablewidth=${#_items[@]};
		done

		_db_cellcount=${#_db_cells[@]};
		
		_db._checksum "${_db_rows[0]}" "$_db_rowcount" "$_db_cellcount";
		_db_isvarified=$?;
	fi
}

function _db._checksum() {
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

function _db._print() {
	if [[ $_db_isvarified == 1 ]];
	then
		for (( _i=0; _i<=$((_db_cellcount-_db_tablewidth)); _i+=$_db_tablewidth ));
		do
			printf "$_db_print_columnseparator";

			for (( _j=0; _j<$_db_tablewidth; _j++ ));
			do
				printf "${_db_cells[$((_i+_j))]}";

				printf "$_db_print_columnseparator";
				if ! [[ -z $1 ]];
				then
					sleep 0.008;
				fi
			done

			printf "$_db_print_rowseparator";
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
