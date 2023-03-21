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
		_dialog._message "$_arg1" "Passed argument";
	fi

	# total count of enlisted channels
	local _count_enlist=`jq '. | length' $_channellist_json_file`;
	_dialog._message "$_count_enlist" "Total enlisted channels";

	# sample jq query
	local _sample_jq_query=`jq '.[] |
	select(.package=="a-la-carte") |
	.category,.package,.name,.cno,.price' $_channellist_json_file`;
	_dialog._message "$_sample_jq_query" "Sample jq query" 35 45;
}

# endregion

# region execute

_construct $1;

# endregion
