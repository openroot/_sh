#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing  bash script
# ---------------------------------

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _entry() {
	local _arg1=$1;
	_fs_const_dir=`dirname $0`; # current directory (relative)

	_channellist_json_file="$_fs_const_dir/packs/channel-list.json";
	_channellist_json=`cat $_channellist_json_file`;

	local _numberofenlist=`echo $_channellist_json | jshon -l`;
	printf "Number of enlist(s): $_numberofenlist\n";

	local _isfound=-1;

	# trying taking channel selection from passed argument from console
	if ! [ -z $_arg1 ]
	then
		printf "Passed argument: $_arg1\n";
	fi

	jq '.[].name' $_channellist_json_file;
}

# endregion

# region execute

_arg1=$1;
_entry $_arg1;

# endregion
