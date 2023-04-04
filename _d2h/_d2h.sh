#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing bash script
# --------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);
# parent directory (relative)
_const_parentdir=$(builtin cd ..; pwd);

# db library
source $_const_parentdir/_db/_library.sh;
# dialogbox library
source $_const_parentdir/_dialogbox/_library.sh;

# regionend

# region function

function _d2h._construct() {
	_arg1=$1;

	_d2h_channels_db_file="$_const_currentdir/_packs/channel-list.txt";
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

	# _db._read
	_db._read "$_d2h_channels_db_file";
	_d2h_channels_db_rows=("${_db_rows[@]}");
	_d2h_channels_db_rowcount=$_db_rowcount;
	_d2h_channels_db_cells=("${_db_cells[@]}");
	_d2h_channels_db_cellcount=$_db_cellcount;
	_d2h_channels_db_tablewidth=$_db_tablewidth;
	_d2h_channels_db_isvarified=$_db_isvarified;

	#_db._print
	#_db._print "1";

	# _db._searchrows
	local _querystring="4|news|t|t|2|bst|t|t|5|73|f|t|";

	_db._searchrows "$_querystring";
	
	if [[ $_db_searchrows_result != -1 ]];
	then
		_db._bardelimitedstringtoarray "$_db_searchrows_result";
		local _rows=("${_db_array[@]}");

		echo "Query String: $_querystring";
		echo "Found Number of Rows: ${#_rows[@]}";
		for (( _i=0; _i<${#_rows[@]}; _i++ ));
		do
			printf "${_rows[$_i]} ";

			_db._getrow "${_rows[$_i]}";
			if [[ $_db_getrow_result != -1 ]];
			then
				echo "${_db_getrow_result[@]}";
			fi
		done
	fi

	# _db._getrow
	_db._getrow "543" "6";

	if [[ $_db_getrow_result != -1 ]];
	then
		printf "\nLast Row, Last Cell: $_db_getrow_result\n";
	fi

	#_d2h._searchbyname;
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
