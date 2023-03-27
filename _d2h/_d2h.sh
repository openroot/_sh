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

	# json file having channel enlist
	_channellist_json_file="$_const_currentdir/packs/channel-list.json";

	_d2h._app;
}

function _d2h._app() {
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

_d2h._construct "$1";

# endregion
