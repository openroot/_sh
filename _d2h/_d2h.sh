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
	_db_print_cellseparator=" | ";
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

	#_db._print "1";

	local _querystring="4|news|2|bst|5|73|";
	_db._searchrows "caseinsensitive_part" "$_querystring";
	if [[ $_db_searchrows_result != -1 ]];
	then
		_db._bardelimitedstringtoarray "$_db_searchrows_result";
		local _rows=("${_db_array[@]}");

		echo "Query string; $_querystring";
		echo "Found number of rows: ${#_db_array[@]}";
		for (( _i=0; _i<${#_db_array[@]}; _i++ ));
		do
			printf "${_db_array[$_i]} ";

			_db._getrow "${_db_array[$_i]}";
			if [[ $_db_getrow_result != -1 ]];
			then
				echo "${_db_getrow_result[@]}";
			fi
		done
	fi

	_db._getrow "543" "6";
	if [[ $_db_getrow_result != -1 ]];
	then
		printf "\nLast row, last cell: $_db_getrow_result\n";
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
		local _i=-1;
		for (( _i=0; _i<=$((_db_cellcount-_db_tablewidth)); _i+=$_db_tablewidth ));
		do
			printf "$_db_print_cellseparator";

			local _j=-1;
			for (( _j=0; _j<$_db_tablewidth; _j++ ));
			do
				printf "${_db_cells[$((_i+_j))]}";

				printf "$_db_print_cellseparator";
				if ! [[ -z $1 ]];
				then
					sleep 0.008;
				fi
			done

			printf "$_db_print_rowseparator";
		done
	fi
}

function _db._searchrows() {
	local _action=$1;
	local _queryset=$2;

	_db_searchrows_result="";

	_db._bardelimitedstringtoarray "$_queryset";
	local _querysetarray=("${_db_array[@]}");

	local _querysetarraycount=${#_querysetarray[@]};
	local _querysetcount=$((_querysetarraycount/2));

	if [[ $_db_isvarified == 1 ]];
	then
		# each ' line '
		local _i=-1;
		for (( _i=0; _i<=$((_db_cellcount-_db_tablewidth)); _i+=$_db_tablewidth ));
		do
			local _rownumber=$(((_i/_db_tablewidth)+1));

			local _issuccess=0;
			local _s=-1;
			for (( _s=0; _s<$_querysetarraycount; _s+=2 ));
			do
				local _celldata="${_db_cells[$((_i+${_querysetarray[$_s]}-1))]}";
				local _data="${_querysetarray[$((_s+1))]}";

				case $_action in
					"casesensitive_part")
						if [[ $_celldata == *"$_data"* ]];
						then
							_issuccess=$((_issuccess+1));
						fi
					;;

					"caseinsensitive_part")
						if [[ ${_celldata,,} == *"${_data,,}"* ]];
						then
							_issuccess=$((_issuccess+1));
						fi
					;;

					*)
					;;
				esac

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
		if [[ $_rownumber < $((_db_rowcount+1)) ]];
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
				if [[ $_cellnumber < $((_db_tablewidth+1)) ]];
				then
					_db_getrow_result="${_db_cells[$((_init+_cellnumber-1))]}";
				fi
			fi
		fi
	fi
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

# endregion

# region execute

_d2h._construct "$1";

# endregion
