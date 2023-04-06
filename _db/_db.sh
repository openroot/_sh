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
	echo "--------------------------------------------[[ SEARCH ROWS ]]-";

	local _querystring="4|news|t|t|2|bst|t|t|5|73|f|t|;1|business news|t|t|";

	_db._searchrows "$_querystring";
	
	if [[ "${#_db_searchrows_foundrows[@]}" > 0 ]];
	then
		local _rows=("${_db_searchrows_foundrows[@]}");

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

	echo "--------------------------------------------------------------"; echo;

	# _db._getrow
	echo "----------------------------------------[[ GET ROW OR CELL ]]-";

	_db._getrow "543" "6";

	if [[ $_db_getrow_result != -1 ]];
	then
		printf "Last Row, Last Cell => $_db_getrow_result\n";
	fi

	echo "--------------------------------------------------------------"; echo;

	# _db._getuniquevalues
	echo "---------------------------------------[[ GET UNIQUE VALUE ]]-";

	local _cellnumber=1;
	echo "Getting Unique Values of Cell Number: $_cellnumber";
	_db._getuniquevalues "$_cellnumber";

	_db._array._freezecells "1" "${_db_getuniquevalues_result[@]}";
	local _finalresult=("${_db_array_freezecells_result[@]}");

	local _i=-1;
	for (( _i=0; _i<${#_finalresult[@]}; _i++ ));
	do
		echo "$((_i+1)) => ${_finalresult[$_i]}";
	done

	echo "--------------------------------------------------------------"; echo;

	echo "---------------------------------------------[[ UPDATE ROW ]]-";

	#_db._updaterow "1" "" "Acategory|Bpackage|Clanguage|Dname|Ecno|Fprice|";
	_db._updaterow "1" "6|5|4|3|1|2|" "Acategory|Bpackage|Clanguage|Dname|Ecno|Fprice|";

	echo "--------------------------------------------------------------"; echo;




	echo;echo;
	read -rp "Press any key to exit .. " "_dump";
}

# endregion

# region execute

_db._construct;

# endregion