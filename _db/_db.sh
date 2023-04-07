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
	_db._operation_fresh_db;

	echo;echo;
	read -rp "Press any key to exit .. " "_dump";
}

function _db._operation_sample_db () {
	local _file="$_const_currentdir/_sample_db/sample-db.txt";

	echo "DB File: $_file"; echo;

	# _db._read
	_db._read "$_file";
	local _readissuccess=$?;

	if [[ $_readissuccess -eq 1 ]];
	then

		local _sample_db_db_file="$_db_file";
		local _sample_db_db_rowcount=$_db_rowcount;
		local _sample_db_db_cells=("${_db_cells[@]}");
		local _sample_db_db_cellcount=$_db_cellcount;
		local _sample_db_db_tablewidth=$_db_tablewidth;
		local _sample_db_db_isvarified=$_db_isvarified;

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
			echo "${#_db_cells[@]} =>";
		fi

		echo "--------------------------------------------------------------"; echo;

		echo "---------------------------------------------[[ DELETE ROW ]]-";

		_db._deleterow "2";
		_db._deleterow "2";
		local _issuccess=$?;
		if [[ $_issuccess -eq 1 ]];
		then
			echo "Row Deleted Successfully.";
			echo "${#_db_cells[@]} =>";
		fi

		echo "--------------------------------------------------------------"; echo;

		echo "---------------------------------------------[[ INSERT ROW ]]-";

		_db._insertrow "1|2|3|4|5|6" "1";
		local _issuccess=$?;
		if [[ $_issuccess -eq 1 ]];
		then
			echo "Row Inserted Successfully.";
			echo "${#_db_cells[@]} =>";
		fi


		# uncommenting the following function ' _db._write ' will write changes to the ' source DB file ',
		# can have this line placed after any virtual changes to the DB to write it to disk back.
		# _db._write "$_sample_db_db_file";
		# local _dbwriteissuccess=$?;
		# if [[ $_dbwriteissuccess -eq 1 ]];
		# then
		# 	_db._print "t";
		# else
		# 	echo "DB Write Error Code: $_dbwriteissuccess";
		# fi

		echo "--------------------------------------------------------------"; echo;
		
	elif [[ $_readissuccess -eq 4 ]];
	then
		echo "DB File Unavailable";
	fi
}

function _db._operation_fresh_db () {
	local _file="$_const_currentdir/_sample_db/fresh-db.txt";

	echo "DB File: $_file"; echo;

	# _db._dbcreate
	_db._dbcreate "$_file" "3";
	local _dbcreateissuccess=$?;

	if [[ $_dbcreateissuccess -ne 1 ]];
	then
		echo "DB Create Unsuccessfull. Error Code: $_dbcreateissuccess";
	fi

	# _db._read
	_db._read "$_file";
	local _readissuccess=$?;

	if [[ $_readissuccess -eq 1 ]];
	then

		local _fresh_db_db_file="$_db_file";
		local _fresh_db_db_rowcount=$_db_rowcount;
		local _fresh_db_db_cells=("${_db_cells[@]}");
		local _fresh_db_db_cellcount=$_db_cellcount;
		local _fresh_db_db_tablewidth=$_db_tablewidth;
		local _fresh_db_db_isvarified=$_db_isvarified;

		echo "---------------------------------------------[[ INSERT ROW ]]-";

			_db._insertrow "1|2|3|";
			local _issuccess=$?;
			if [[ $_issuccess -eq 1 ]];
			then
				echo "Row Inserted Successfully.";
				echo "${#_db_cells[@]} =>";
			fi


			# uncommenting the following function ' _db._write ' will write changes to the ' source DB file ',
			# can have this line placed after any virtual changes to the DB to write it to disk back.
			_db._write "$_fresh_db_db_file";
			local _dbwriteissuccess=$?;
			if [[ $_dbwriteissuccess -eq 1 ]];
			then
				_db._print "t";
			else
				echo "DB Write Error Code: $_dbwriteissuccess";
			fi

		echo "--------------------------------------------------------------"; echo;

	else
		echo "DB Read Unsuccessfull. Error Code: $_readissuccess";
	fi
}

# endregion

# region execute

_db._construct;

# endregion