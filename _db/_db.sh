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
	_db._app;
}

function _db._app() {
	clear;

	_db._operation_sample_db;

	echo;echo;
	read -rp "Press any key to exit .. " "_dump";
}

function _db._operation_sample_db () {
	local _file="$_const_currentdir/_sample_db/sample-db.txt";

	# _db._read
	_db._read "$_file";
	
	_sample_db_db_file="$_db_file";
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
	local _issuccess=$?;
	if [[ $_issuccess -eq 1 ]];
	then
		echo "Row Updated Successfully.";
		#echo "${#_db_cells[@]} => ${_db_cells[@]}";
		echo "${#_db_cells[@]} =>";
		# TODO: update write into orginal file
	fi

	echo "--------------------------------------------------------------"; echo;

	echo "---------------------------------------------[[ DELETE ROW ]]-";

	_db._deleterow "2";
	_db._deleterow "2";
	local _issuccess=$?;
	if [[ $_issuccess -eq 1 ]];
	then
		echo "Row Deleted Successfully.";
		#echo "${#_db_cells[@]} => ${_db_cells[@]}";
		echo "${#_db_cells[@]} =>";
		# TODO: update write into orginal file
	fi

	echo "--------------------------------------------------------------"; echo;

	echo "---------------------------------------------[[ INSERT ROW ]]-";

	_db._insertrow "1|2|3|4|5|6" "1";
	local _issuccess=$?;
	if [[ $_issuccess -eq 1 ]];
	then
		echo "Row Inserted Successfully.";
		#echo "${#_db_cells[@]} => ${_db_cells[@]}";
		echo "${#_db_cells[@]} =>";
		# TODO: update write into orginal file
	fi

	echo "--------------------------------------------------------------"; echo;
}

# endregion

# region execute

_db._construct;

# endregion