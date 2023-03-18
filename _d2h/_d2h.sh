#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing  bash script
# ---------------------------------

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _tempfn() {
	_fs_const_dir=`dirname $0`; # current directory (relative)

	_channellist_json_file="$_fs_const_dir/packs/channel-list.json";

	_numberofenlist=`cat $_channellist_json_file | jshon -l`;
	printf "Number of enlist(s): $_numberofenlist\n";
}

# endregion

# region execute

_tempfn;

# endregion
