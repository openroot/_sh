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
	# create directory "_temporary_container" at 'source caller' directory if not already exists
	_temporarycontainerdirectoryname="_temporary_container";
	if ! [ -d "$_temporarycontainerdirectoryname" ];
	then
		mkdir $(printf "$_temporarycontainerdirectoryname";);
	fi

	_db_print_rowseparator="\n";
	_db_print_cellseparator="|";

	_db_file="";
	_db_rowcount=-1;
	_db_cells=();
	_db_cellcount=-1;
	_db_tablewidth=-1;
	_db_isvarified=-1;

	_temp_db_file="";
	_temp_db_rows=();
	_temp_db_rowcount=-1;
	_temp_db_cells=();
	_temp_db_cellcount=-1;
	_temp_db_tablewidth=-1;
	_temp_db_isvarified=-1;
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

function _db._semicolondelimitedstringtoarray() {
	local _semicolondelimitedstring=$1;

	# converting semicolon delimited string into array
	local _oifs=$IFS;
	IFS=$';';
	_db_array=($_semicolondelimitedstring);
	IFS=$_oifs;
}

function _db._array._contains() {
	local _array _searchstring="$1";
	shift;
	for _array;
	do
		[[ "$_array" == "$_searchstring" ]] && return 1;
	done
	return 0;
}

function _db._array._freezecells() {
	local _array _freezevalue="$1";
	shift;

	_db_array_freezecells_result=();

	local _i=0;
	for _array;
	do
		if [[ $_i -ge $_freezevalue ]];
		then
			_db_array_freezecells_result+=("$_array");
		fi
		_i=$((_i+1));
	done
}

function _db._array._sort() {
	local _array=("$@");
	local _arraycount=${#_array[@]};

	local _flag=1;
	local _i=-1;
	for (( _i=0; _i<$((_arraycount-1)); _i++ ))
	do
		_flag=0;
		local _j=-1;
		for (( _j=0; _j<$((_arraycount-1-_i)); _j++ ))
		do
			if [[ ${_array[$_j]} -gt ${_array[$((_j+1))]} ]]
			then
				local _temp=${_array[$_j]};
				_array[$_j]=${_array[$((_j+1))]};
				_array[$((_j+1))]=$_temp;
				_flag=1;
			fi
		done

		if [[ $_flag -eq 0 ]]; then break; fi
	done

	_db_array_sorted=("${_array[@]}");
}

function _db._dbreset() {
	_db_file="";
	_db_rowcount=-1;
	_db_cells=();
	_db_cellcount=-1;
	_db_tablewidth=-1;
	_db_isvarified=-1;

	_temp_db_file="";
	_temp_db_rows=();
	_temp_db_rowcount=-1;
	_temp_db_cells=();
	_temp_db_cellcount=-1;
	_temp_db_tablewidth=-1;
	_temp_db_isvarified=-1;
}

function _db._read() {
	local _file=$1;

	local _issuccess=-1;

	_db._read._temporary "$_file";
	local _db_read_temporaryissuccess=$?;

	if [[ $_db_read_temporaryissuccess -eq 1 ]];
	then
		_db_file="$_temp_db_file";
		_db_rowcount=$_temp_db_rowcount;
		_db_cells=("${_temp_db_cells[@]}");
		_db_cellcount=$_temp_db_cellcount;
		_db_tablewidth=$_temp_db_tablewidth;
		_db_isvarified=$_temp_db_isvarified;
		_issuccess=1;
	else
		_issuccess=$_db_read_temporaryissuccess;
	fi

	return $_issuccess;
}

function _db._read._temporary() {
	local _file=$1;

	local _issuccess=-1;

	if ! [[ -z $_file ]];
	then
		_issuccess=0;

		_db._dbreset;

		if [[ -f $_file ]];
		then
			if [[ $_temp_db_rowcount -eq -1 ]];
			then
				_temp_db_file="$_file";

				_db._newlinedelimitedstringtoarray "$(cat "$_temp_db_file")";

				_temp_db_rows=("${_db_array[@]}");

				_temp_db_rowcount=${#_temp_db_rows[@]};

				local _row=-1;
				for _row in "${_temp_db_rows[@]}";
				do
					local _rowline=${_row:0:${#_row}-1};	# removing last most char of line

					_db._bardelimitedstringtoarray "$_rowline";
					local _columns=("${_db_array[@]}");

					_temp_db_cells+=("${_columns[@]}");
					
					_temp_db_tablewidth=${#_columns[@]};
				done

				_temp_db_cellcount=${#_temp_db_cells[@]};
				
				_db._checksum "${_temp_db_rows[0]}" "$_temp_db_rowcount" "$_temp_db_cellcount";
				_temp_db_isvarified=$?;

				if [[ $_temp_db_isvarified -eq 1 ]];
				then
					_issuccess=1;
				fi
			fi
		else
			_issuccess=4;
		fi
	fi

	return $_issuccess;
}

function _db._checksum() {
	local _firstrow=$1;
	local _db_rowcount=$2;
	local _db_cellcount=$3;

	if ! [ -z $_firstrow ];
	then
		if [[ $_db_rowcount -gt 0 ]];
		then
			local _rowline=${_firstrow:0:${#_firstrow}-1};	# removing last most char of line

			_db._bardelimitedstringtoarray "$_rowline";
			local _columns=("${_db_array[@]}");

			local _firstrow_cellcount=${#_columns[@]};

			if [[ $(($_db_rowcount*$_firstrow_cellcount)) -eq $_db_cellcount ]];
			then
				return 1;
			else
				return -1;
			fi
		fi
	fi
}

function _db._print() {
	if [[ $_db_isvarified == 1 ]];
	then
		_db_finishloop=-1;

		local _i=-1;
		for (( _i=0; _i<$_db_cellcount; _i+=$_db_tablewidth ));
		do
			printf "$_db_print_cellseparator";

			local _j=-1;
			for (( _j=0; _j<$_db_tablewidth; _j++ ));
			do
				printf "${_db_cells[$((_i+_j))]}";
				#printf "$(tput sitm)"${_db_cells[$((_i+_j))]}"$(tput sgr0)";

				printf "$_db_print_cellseparator";

				if [[ $1 == "t" ]];then sleep 0.001; fi
			done

			printf "$_db_print_rowseparator";
			
			if [[ $_db_finishloop -ne -1 ]];then break; fi
		done
	fi
}

function _db._searchrows() {
	local _querylines=$1;

	_db_searchrows_foundrows=();
	local _querysetwidth=4;

	# separating string to array of ' query lines '
	_db._semicolondelimitedstringtoarray "$_querylines";
	local _querylinearray=("${_db_array[@]}");
	local _querylinearraycount=${#_querylinearray[@]};

	if [[ $_db_isvarified -eq 1 ]];
	then
		# each ' query line '
		local _ql=-1;
		for (( _ql=0; _ql<$_querylinearraycount; _ql++ ));
		do

			# separating string of ' query line ' to array of ' query set '
			_db._bardelimitedstringtoarray "${_querylinearray[$_ql]}";
			local _querysetarray=("${_db_array[@]}");
			local _querysetarraycount=${#_querysetarray[@]};
			local _querysetcount=$((_querysetarraycount/_querysetwidth));

			# each ' row '
			local _i=-1;
			for (( _i=0; _i<=$((_db_cellcount-_db_tablewidth)); _i+=$_db_tablewidth ));
			do
				local _rownumber=$(((_i/_db_tablewidth)+1));

				# persistent ' cell '
				local _issuccess=0;

				local _s=-1;
				for (( _s=0; _s<$_querysetarraycount; _s+=$_querysetwidth ));
				do
					local _cellnumber=${_querysetarray[$_s]};
					if [[ $_cellnumber -ge 1 ]];
					then
						if [[ $_cellnumber -le $_db_tablewidth ]];
						then
							# realising ' a set ' of clause arguments into definite vars
							local _celldata="${_db_cells[$((_i+$_cellnumber-1))]}";
							local _data="${_querysetarray[$((_s+1))]}";
							local _iscaseinsensitive=1; if [[ "${_querysetarray[$((_s+2))]}" == "f" ]];then _iscaseinsensitive=0; fi;
							local _ispartdata=1; if [[ "${_querysetarray[$((_s+3))]}" == "f" ]];then _ispartdata=0; fi;

							if [[ $_iscaseinsensitive -eq 1 ]];
							then
								if [[ $_ispartdata -eq 1 ]];
								then
									if [[ ${_celldata,,} == *"${_data,,}"* ]];then _issuccess=$((_issuccess+1)); fi
								else
									if [[ ${_celldata,,} == "${_data,,}" ]];then _issuccess=$((_issuccess+1)); fi
								fi
							else
								if [[ $_ispartdata -eq 1 ]];
								then
									if [[ $_celldata == *"$_data"* ]];then _issuccess=$((_issuccess+1)); fi
								else
									if [[ $_celldata == "$_data" ]];then _issuccess=$((_issuccess+1)); fi
								fi
							fi
						fi
					fi
				done

				# if persistent ' cell matches ' the count of total number of clauses
				if [[ $_querysetcount -eq $_issuccess ]];
				then
					# add unique row number interest
					_db._array._contains "$_rownumber" "${_db_searchrows_foundrows[@]}";
					if [[ $? -eq 0 ]]; then _db_searchrows_foundrows+=($_rownumber); fi
				fi

			done

		done
	fi

	# sort resulted array of row numbers
	_db._array._sort "${_db_searchrows_foundrows[@]}";
	_db_searchrows_foundrows=("${_db_array_sorted[@]}");
}

function _db._getrow() {
	local _rownumber=$1;
	local _cellnumber=$2;

	_db_getrow_result=-1;

	if [[ $_db_isvarified -eq 1 ]];
	then
		if [[ $_rownumber -gt 0 ]];
		then
			if [[ $_rownumber -le $_db_rowcount ]];
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
					if [[ $_cellnumber -le $_db_tablewidth ]];
					then
						_db_getrow_result="${_db_cells[$((_init+_cellnumber-1))]}";
					fi
				fi
			fi
		fi
	fi
}

function _db._getuniquevalues() {
	local _cellnumber=$1;

	_db_getuniquevalues_result=-1;

	if [[ $_db_isvarified -eq 1 ]];
	then
		if [[ $_cellnumber -gt 0 ]];
		then
			if [[ $_cellnumber -le _db_tablewidth ]];
			then
				_db_getuniquevalues_result=();

				local _i=-1;
				for (( _i=0; _i<$_temp_db_cellcount; _i+=$_db_tablewidth ));
				do
					local _value="${_db_cells[$((_i+_cellnumber-1))]}";

					# if ' cell value ' is not empty
					if ! [[ -z $_value ]];
					then
						# add unique value interest
						_db._array._contains "$_value" "${_db_getuniquevalues_result[@]}";
						if [[ $? -eq 0 ]]; then _db_getuniquevalues_result+=("$_value"); fi
					fi
				done
			fi
		fi
	fi
}

function _db._updaterow() {
	local _rownumber=$1;
	local _cellnumbers=$2;
	local _rowline=$3;

	local _issuccess=-1;

	if [[ $_db_isvarified -eq 1 ]];
	then
		if [[ $_rownumber -gt 0 ]];
		then
			if [[ $_rownumber -le $_db_rowcount ]];
			then
				_issuccess=0;

				_db._bardelimitedstringtoarray "$_rowline";
				local _columns=("${_db_array[@]}");

				local _columnscount=${#_columns[@]};

				if ! [[ -z $_cellnumbers ]];
				then
					_db._bardelimitedstringtoarray "$_cellnumbers";
					local _cellnumbersarray=("${_db_array[@]}");

					local _cellnumbersarraycount=${#_cellnumbersarray[@]};

					if [[ $_columnscount -eq $_cellnumbersarraycount ]];
					then
						if [[ $_cellnumbersarraycount -le $_db_tablewidth ]];
						then
							local _i=-1;
							for (( _i=0; _i<$_cellnumbersarraycount; _i++ ));
							do
								local _cellnumber=${_cellnumbersarray[$_i]};
								if [[ $_cellnumber -le $_db_tablewidth ]];
								then
									_db_cells[$((((_rownumber-1)*_db_tablewidth)+_cellnumber-1))]="${_columns[$_i]}";
									_issuccess=$((_issuccess+1));
								fi
							done
							if [[ $_issuccess -eq $_cellnumbersarraycount ]]; then _issuccess=1; fi
						fi
					fi
				else
					if [[ $_columnscount -eq $_db_tablewidth ]];
					then
						local _i=-1;
						for (( _i=0; _i<$_columnscount; _i++ ));
						do
							_db_cells[$((((_rownumber-1)*_db_tablewidth)+_i))]="${_columns[$_i]}";
							_issuccess=$((_issuccess+1));
						done
						if [[ $_issuccess -eq $_db_tablewidth ]]; then _issuccess=1; fi
					fi
				fi
			fi
		fi
	fi

	return $_issuccess;
}

function _db._deleterow() {
	local _rownumber=$1;

	local _issuccess=-1;

	if [[ $_db_isvarified -eq 1 ]];
	then
		if [[ $_rownumber -gt 0 ]];
		then
			if [[ $_rownumber -le $_db_rowcount ]];
			then
				_issuccess=0;
				local _firstslab=0;
				local _firstslablength=$(((_rownumber-1)*6));
				local _secondslab=$((_firstslablength+_db_tablewidth));
				local _secondslablength=$_db_cellcount;

				_temp_db_cells=();
				_temp_db_cells+=("${_db_cells[@]:$_firstslab:$_firstslablength}");
				_temp_db_cells+=("${_db_cells[@]:$_secondslab:$_secondslablength}");

				_temp_db_cellcount=${#_temp_db_cells[@]};

				if [[ $_temp_db_cellcount -eq $(((_db_rowcount-1)*_db_tablewidth)) ]]
				then
					_db_rowcount=$((_db_rowcount-1));
					_db_cells=("${_temp_db_cells[@]}");
					_db_cellcount=$_temp_db_cellcount;
					_issuccess=1;
				fi
			fi
		fi
	fi

	return $_issuccess;
}

function _db._insertrow() {
	local _rowline=$1;
	local _rownumber=$2;

	local _issuccess=-1;

	if [[ $_db_isvarified -eq 1 ]];
	then
		if [[ -z $_rownumber ]]; then _rownumber=$((_db_rowcount+1)); fi
		
		if [[ $_rownumber -gt 0 ]];
		then
			if [[ $_rownumber -le $((_db_rowcount+1)) ]];
			then
				if ! [[ -z $_rowline ]];
				then
					_issuccess=0;

					_db._bardelimitedstringtoarray "$_rowline";
					local _columns=("${_db_array[@]}");

					local _columnscount=${#_columns[@]};
					if [[ $_columnscount -le $_db_tablewidth ]];
					then
						local _temp_db_row=();
						local _i=-1;
						for (( _i=0; _i<$_db_tablewidth; _i++ ));
						do
							if [[ "${_columns[$_i]}" != "" ]];
							then
								_temp_db_row+=("${_columns[$_i]}");
							else
								_temp_db_row+=("");
							fi
						done

						if [[ ${#_temp_db_row[@]} -eq $_db_tablewidth ]];
						then
							local _firstslab=0;
							local _firstslablength=$(((_rownumber-1)*6));
							local _secondslab=$_firstslablength;
							local _secondslablength=$_db_cellcount;

							_temp_db_cells=();
							_temp_db_cells+=("${_db_cells[@]:$_firstslab:$_firstslablength}");
							_temp_db_cells+=("${_temp_db_row[@]}");
							_temp_db_cells+=("${_db_cells[@]:$_secondslab:$_secondslablength}");

							_temp_db_cellcount=${#_temp_db_cells[@]};

							if [[ $_temp_db_cellcount -eq $(((_db_rowcount+1)*_db_tablewidth)) ]];
							then
								_db_rowcount=$((_db_rowcount+1));
								_db_cells=("${_temp_db_cells[@]}");
								_db_cellcount=$_temp_db_cellcount;
								_issuccess=1;
							fi
						fi
					fi
				fi
			fi
		fi
	fi

	return $_issuccess;
}

function _db._dbcreate() {
	local _file=$1;
	local _tablewidth=$2;

	local _issuccess=-1;

	if [[ "$_file" != "" ]];
	then
		if ! [[ -z $_tablewidth ]];
		then
			if [[ $_tablewidth -ge 1 ]];
			then
				if [[ $_tablewidth -le 1024 ]];
				then
					_issuccess=0;

					_db._dbreset;

					if [[ $_db_isvarified -eq -1 ]];
					then
						if [[ -f $_file ]];
						then
							_issuccess=3;
						else
							local _writedata="";
							local _i=-1;
							for (( _i=0; _i<$_tablewidth; _i++ ));
							do
								_writedata+="column$((_i+1))";
								_writedata+="$_db_print_cellseparator";
							done
							_writedata+="\n";
							{
								$(printf "$_writedata" > "$_file");
							} || { _issuccess=5; }

							if [[ $_issuccess -ne 5 ]];
							then
								_db_file="$_file";
								_db_rowcount=1;
								_db_cells=();
								_db_cellcount=0;
								_db_tablewidth=$_tablewidth;
								_db_isvarified=1;

								_issuccess=1;
							fi
						fi
					fi
				fi
			fi
		fi
	fi

	return $_issuccess;
}

function _db._dbaddcolumn() {
	echo "nothing";
}

function _db._dbremovecolumn() {
	echo "nothing";
}

function _db._write() {
	local _file=$1;

	local _issuccess=-1;

	if ! [[ -z $_file ]];
	then
		_issuccess=0;

		if [[ -f $_file ]];
		then

			if [[ $_db_isvarified -eq 1 ]];
			then
				if [[ $_db_rowcount -gt 0 ]];
				then
					if [[ $_db_cellcount -gt 0 ]];
					then
						if [[ $((_db_rowcount*_db_tablewidth)) -eq $_db_cellcount ]];
						then
							local _writedata="";
							local _i=-1;
							for (( _i=0; _i<$_db_cellcount; _i+=$_db_tablewidth ));
							do
								local _j=-1;
								for (( _j=0; _j<$_db_tablewidth; _j++ ));
								do
									_writedata+="${_db_cells[$((_i+_j))]}";
									_writedata+="$_db_print_cellseparator";
								done
								_writedata+="$_db_print_rowseparator";
							done

							local _file_temp="$_temporarycontainerdirectoryname/temp-db.txt";
							{
								$(printf "$_writedata" > "$_file_temp");
							} || { _issuccess=5; }

							if [[ $_issuccess -ne 5 ]];
							then
								_db._read._temporary "$_file_temp";
								local _db_read_temporaryissuccess=$?;

								if [[ $_db_read_temporaryissuccess -eq 1 ]];
								then
									{
										$(cp "$_file_temp" "$_file"; rm "$_file_temp";);
									} || { _issuccess=5; }
									
									if [[ $_issuccess -ne 5 ]];
									then
										_db._read "$_file";
										return $?;
									fi
								else
									_issuccess=$_db_read_temporaryissuccess;
								fi
							fi
						fi
					fi
				fi
			fi
		
		fi
	fi

	return $_issuccess;
}

# regionend

# region execute

_db._construct;

# regionend