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

_d2h_finishloop=-1;
trap _d2h._trap SIGQUIT;


# regionend

# region function

function _d2h._trap() {
	# press Ctrl+\ to stop loop
	_d2h_finishloop=255;
}

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

	_d2h._channels_db;

	while true;
	do
		if [[ $_d2h_finishloop == 255 ]];
		then
			exit;
		else
			_d2h._searchbynameorcategory "$_arg1";

			_d2h_finishloop=$?;
		fi
	done
}

function _d2h._channels_db() {
	_db._read "$_d2h_channels_db_file";
	_d2h_channels_db_rows=("${_db_rows[@]}");
	_d2h_channels_db_rowcount=$_db_rowcount;
	_d2h_channels_db_cells=("${_db_cells[@]}");
	_d2h_channels_db_cellcount=$_db_cellcount;
	_d2h_channels_db_tablewidth=$_db_tablewidth;
	_d2h_channels_db_isvarified=$_db_isvarified;
}

function _d2h._inputbox() {
	local _inputboxinit=$1;
	local _inputboxmessage=$2;
	local _inputboxtitle=$3;

	_dialog._inputbox "$_inputboxinit" "$_inputboxmessage" "$_inputboxtitle" "9" "34";

	_d2h_inputbox_result="$_dialog_inputbox_result";
}

function _d2h._searchbynameorcategory() {
	# taking search term from either console or within app
	local _searchterm="";

	if ! [ -z $_arg1 ]
	then
		# trying taking search term from passed argument from console
		_searchterm="$_arg1";
		unset _arg1; # unset console arg once used
	else
		# take search term within app
		_d2h._inputbox "" "Please enter a \nChannel Name or Category" "Channel Search";
		if [[ $_d2h_inputbox_result != -1 ]];
		then
			_searchterm="$_d2h_inputbox_result";
		else
			return $_d2h_inputbox_result; # return status 'cancel (255)' persistent to exit app
		fi
	fi

	# have search on search term
	local _foundrows="";

	# query
	local _querystring="4|$_searchterm|t|t|;1|$_searchterm|t|t|;";
	_db._searchrows "$_querystring";
	if [[ ${#_db_searchrows_foundrows[@]} -gt 0 ]]; then
		_foundrows=("${_db_searchrows_foundrows[@]}");
		local _foundrowscount=${#_foundrows[@]};
	fi
	
	# process query result
	if [[ $_foundrowscount -gt 0 ]];
	then
		# generating menu items array
		local _menuitems=();
		for (( _i=0; _i<$_foundrowscount; _i++ ));
		do
			# fetching db row value from row number
			_db._getrow "${_foundrows[$_i]}";
			if [[ $_db_getrow_result != -1 ]];
			then
				local _label="";
				if [[ "${_db_getrow_result[4]}" != "" ]]; then _label+="${_db_getrow_result[4]}"; fi
				_label+="<>";
				if [[ "${_db_getrow_result[3]}" != "" ]]; then _label+="${_db_getrow_result[3]}"; fi
				_label+="<>";
				if [[ "${_db_getrow_result[5]}" != "" ]]; then _label+="${_db_getrow_result[5]}"; fi
				_menuitems+=("$_label");
			fi
		done

		# generating labels from menu items array
		_dialog._menu._labelgenerator "${_menuitems[@]}";
		local _menuitemslabels=$_dialog_menu_labels;

		# showing menu
		_dialog._menu "$_menuitemslabels" "$_foundrowscount+ Found channels" "Channel List" "50" "75" "5" "<>";

		# processing menu returned result
		if [[ $_dialog_menu_result != -1 ]];
		then
			_dialog._message "${_menuitems[$_dialog_menu_result-1]}" "Channel Selection Returned";
		fi
	fi
}

# endregion

# region execute

_d2h._construct "$1";

# endregion
