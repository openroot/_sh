#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing bash script
# --------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);
# parent directory (relative)
_const_parentdir=$(builtin cd ..; pwd);

# GUI dialog box library
source $_const_parentdir/_dialogbox/_library.sh;

# regionend

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _construct() {
	_arg1=$1;

	# json file having channel enlist
	_channellist_json_file="$_const_currentdir/packs/channel-list.json";

	_app;
}

function _app() {
	# trying taking channel selection from passed argument from console
	if ! [ -z $_arg1 ]
	then
		_dialog._message "Passed argument: $_arg1";
	fi

	# total count of enlisted channels
	_count_enlist=`jq '. | length' $_channellist_json_file`;
	_dialog._message "Total enlisted channels: $_count_enlist";

	# sample jq query
	#jq '.[] |
	#select(.package=="a-la-carte") |
	#.category,.package,.name,.cno,.price' $_channellist_json_file;

	local _message="Hello\nWorld!";
	local _title="Sample Message";
	_dialog._message "$_message" "$_title";

	local _items="1;A|pp for test buddies;2;B|ook of jealous intelligent(s);3;C|opy of tutorial(s)";
	_dialog._menu "$_items" "List of items" "Sample Menu" 10 55;
	_dialog._message "Selection returned: $_dialog_menu_selection";
}

# endregion

# region execute

_construct $1;

# endregion
