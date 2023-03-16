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

	_xmlfile1="$_fs_const_dir/packs/_testxml.xml";
# 	_xmlfile1="$_fs_const_dir/packs/dd-pack.xml";
# 	cat $_xmlfile1;
	xmlstarlet val $_xmlfile1;
}

# endregion

# region execute

_tempfn;

# endregion
