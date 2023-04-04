#!/bin/bash
# Name: _db.sh
# Purpose: db bash script
# -----------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);

# db library
source $_const_currentdir/_library.sh;

# regionend

# region function

function _db._construct() {
	_sample_db_db_file="$_const_currentdir/_sample_db/sample-db.txt";
	_sample_db_db_rows=();
	_sample_db_db_rowcount=-1;
	_sample_db_db_cells=();
	_sample_db_db_cellcount=-1;
	_sample_db_db_tablewidth=-1;
	_sample_db_db_isvarified=-1;

	_db._app;
}

function _db._app() {
	# _db._read
	_db._read "$_sample_db_db_file";
	_sample_db_db_rows=("${_db_rows[@]}");
	_sample_db_db_rowcount=$_db_rowcount;
	_sample_db_db_cells=("${_db_cells[@]}");
	_sample_db_db_cellcount=$_db_cellcount;
	_sample_db_db_tablewidth=$_db_tablewidth;
	_sample_db_db_isvarified=$_db_isvarified;

	#_db._print
	_db._print "1";

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
}

# endregion

# region execute

_db._construct;

# endregion