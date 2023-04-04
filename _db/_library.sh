 #!/bin/bash
# Name: _library.sh
# Purpose: db library bash script
# -------------------------------

# region script requires

_db_finishloop=-1;
trap _db._trap SIGQUIT;

# endregion

# region function

function _db._trap() {
	# press Ctrl+\ to stop loop
	_db_finishloop=1;
}

function _db._construct() {
	_db_print_rowseparator="\n";
	_db_print_cellseparator=" | ";
	_db_file="";
	_db_rows=();
	_db_rowcount=-1;
	_db_cells=();
	_db_cellcount=-1;
	_db_tablewidth=-1;
	_db_isvarified=-1;
}

function _db._newlinedelimitedstringtoarray() {
	local _newlinedelimitedstring=$1;

	# converting newline delimited string into array
	local _oifs=$IFS;
	IFS=$'\n';
	_db_array=($_newlinedelimitedstring);
	IFS=$_oifs;
}

function _db._bardelimitedstringtoarray() {
	local _bardelimitedstring=$1;

	# converting bar delimited string into array
	local _oifs=$IFS;
	IFS=$'|';
	_db_array=($_bardelimitedstring);
	IFS=$_oifs;
}

function _db._read() {
	_db_file=$1;

	if [[ $_db_rowcount == -1 ]];
	then
		_db._newlinedelimitedstringtoarray "$(cat "$_db_file")";

		_db_rows=("${_db_array[@]}");

		_db_rowcount=${#_db_rows[@]};

		local _row=-1;
		for _row in "${_db_rows[@]}";
		do
			local _rowline=${_row:0:${#_row}-1};	# removing last most char of line

			_db._bardelimitedstringtoarray "$_rowline";
			local _items=("${_db_array[@]}");

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

			_db._bardelimitedstringtoarray "$_rowline";
			local _items=("${_db_array[@]}");

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
		_db_finishloop=-1;

		local _i=-1;
		for (( _i=0; _i<=$((_db_cellcount-_db_tablewidth)); _i+=$_db_tablewidth ));
		do
			printf "$_db_print_cellseparator";

			local _j=-1;
			for (( _j=0; _j<$_db_tablewidth; _j++ ));
			do
				printf "${_db_cells[$((_i+_j))]}";

				printf "$_db_print_cellseparator";

				if [[ $1 == "t" ]];then sleep 0.001; fi
			done

			printf "$_db_print_rowseparator";
			
			if [[ $_db_finishloop != -1 ]];then break; fi
		done
	fi
}

function _db._searchrows() {
	local _queryset=$1;
	local _querysetwidth=4;

	_db_searchrows_result="";

	_db._bardelimitedstringtoarray "$_queryset";
	local _querysetarray=("${_db_array[@]}");

	local _querysetarraycount=${#_querysetarray[@]};
	local _querysetcount=$((_querysetarraycount/_querysetwidth));

	if [[ $_db_isvarified == 1 ]];
	then
		# each ' line '
		local _i=-1;
		for (( _i=0; _i<=$((_db_cellcount-_db_tablewidth)); _i+=$_db_tablewidth ));
		do
			local _rownumber=$(((_i/_db_tablewidth)+1));

			local _issuccess=0;
			local _s=-1;
			for (( _s=0; _s<$_querysetarraycount; _s+=$_querysetwidth ));
			do
				# TODO: Add querystring Join operation ;here
				#for (());
				#do
				local _celldata="${_db_cells[$((_i+${_querysetarray[$_s]}-1))]}";
				local _data="${_querysetarray[$((_s+1))]}";
				local _iscaseinsensitive=1; if [[ "${_querysetarray[$((_s+2))]}" == "f" ]];then _iscaseinsensitive=0; fi;
				local _ispartdata=1; if [[ "${_querysetarray[$((_s+3))]}" == "f" ]];then _ispartdata=0; fi;

				if [[ $_iscaseinsensitive == 1 ]];
				then
					if [[ $_ispartdata == 1 ]];
					then
						if [[ ${_celldata,,} == *"${_data,,}"* ]];then _issuccess=$((_issuccess+1)); fi
					else
						if [[ ${_celldata,,} == "${_data,,}" ]];then _issuccess=$((_issuccess+1)); fi
					fi
				else
					if [[ $_ispartdata == 1 ]];
					then
						if [[ $_celldata == *"$_data"* ]];then _issuccess=$((_issuccess+1)); fi
					else
						if [[ $_celldata == "$_data" ]];then _issuccess=$((_issuccess+1)); fi
					fi
				fi
				#done
			done

			if [[ $_issuccess == $_querysetcount ]];
			then
				_db_searchrows_result+="$_rownumber|";
			fi
		done
	fi

	if [[ $_db_searchrows_result == "" ]];
	then
		_db_searchrows_result=-1;
	fi
}

function _db._getrow() {
	local _rownumber=$1;
	local _cellnumber=$2;

	_db_getrow_result=-1;

	if [[ $_db_isvarified == 1 ]];
	then
		if [[ $_rownumber -lt $((_db_rowcount+1)) ]];
		then
			local _init=$(((_rownumber-1)*_db_tablewidth));
			if [ -z $_cellnumber ]
			then
				_db_getrow_result=();
				local _i=-1;
				for (( _i=$_init; _i<$((_init+_db_tablewidth)); _i++ ));
				do
					_db_getrow_result+=("${_db_cells[$_i]}");
				done
			else
				if [[ $_cellnumber -lt $((_db_tablewidth+1)) ]];
				then
					_db_getrow_result="${_db_cells[$((_init+_cellnumber-1))]}";
				fi
			fi
		fi
	fi
}

# regionend

# region execute

_db._construct;

# regionend