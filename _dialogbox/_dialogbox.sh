#!/bin/bash
# Name: _dialogbox.sh
# Purpose: GUI DialogBox bash script
# ----------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);

# GUI dialog box library
source $_const_currentdir/_library.sh;

# regionend

# region function

trap _trap SIGINT;
function _trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _construct() {
	_app;
}

function _app() {
	local _message="Hello\nWorld!";
	local _title="Sample Message";
	_dialog._message "$_message" "$_title";

	local _items="1;App for test buddies;2;Book of jealous intelligent(s);3;Copy of tutorial(s)";
	_dialog._menu "$_items" "List of items" "Sample Menu" 10 55;
	_dialog._message "Selection returned: $_dialog_menu_result";
}

# endregion

# region execute

_construct;

# endregion
