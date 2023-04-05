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
	clear;

	# _db._read
	_db._read "$_sample_db_db_file";
	_sample_db_db_rows=("${_db_rows[@]}");
	_sample_db_db_rowcount=$_db_rowcount;
	_sample_db_db_cells=("${_db_cells[@]}");
	_sample_db_db_cellcount=$_db_cellcount;
	_sample_db_db_tablewidth=$_db_tablewidth;
	_sample_db_db_isvarified=$_db_isvarified;

	#_db._print
	#_db._print "t";

	# _db._searchrows
	echo "------------------------------------------------[[ SEARCH ROWS ]]-";

	local _querystring="4|news|t|t|2|bst|t|t|5|73|f|t|;1|news|t|t|";

	_db._searchrows "$_querystring";
	
	if [[ $_db_searchrows_result != -1 ]];
	then
		_db._bardelimitedstringtoarray "$_db_searchrows_result";
		local _rows=("${_db_array[@]}");

		echo "Query String: $_querystring"; echo;
		echo "Found Number of Rows: ${#_rows[@]}"; echo;
		for (( _i=0; _i<${#_rows[@]}; _i++ ));
		do
			printf "(Row Number) ${_rows[$_i]} => ";

			_db._getrow "${_rows[$_i]}";
			if [[ $_db_getrow_result != -1 ]];
			then
				echo "${_db_getrow_result[@]}";
			fi
		done
	fi

	echo "------------------------------------------------------------------"; echo;

	# _db._getrow
	echo "--------------------------------------------[[ GET ROW OR CELL ]]-";

	_db._getrow "543" "6";

	if [[ $_db_getrow_result != -1 ]];
	then
		printf "Last Row, Last Cell => $_db_getrow_result\n";
	fi

	echo "------------------------------------------------------------------"; echo;

	echo;echo;
	read -rp "Press any key to exit .. " "_dump";
}

# endregion

# region execute

_db._construct;

# endregion