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
	# _dialog._message
	local _messagestring="Hello\n\"World\"!";
	local _messagetitle="Sample Message";
	_dialog._message "$_messagestring" "$_messagetitle" "6" "28";

	# _dialog._menu
	local _menuitems="1;App for test buddies;2;Book of jealous intelligent(s);3;Copy of tutorial(s);";
	_dialog._menu "$_menuitems" "List of items" "Sample Menu" "11" "45" "3";
	_dialog._message "$_dialog_menu_result" "Selection returned";

	# _dialog._form
	local _formitems="Name;1;0;D Tapader;1;11;17;128;Age;2;0;34;2;11;17;3;E-mail ID;3;0;dev.openroot@gmail.com;3;11;17;64;";
	local _formmessage="Please enter the required information";
	local _formtitle="Sample Form";
	_dialog._form "$_formitems" "$_formmessage" "$_formtitle" "11" "34" "3";
	_dialog._message "$_dialog_form_result" "Form returned values";

	# _dialog._mixedform
	local _mixedformitems="Name;1;0;devop;1;11;17;128;readonly;Secret;2;0;;2;11;17;3;hidden;E-mail ID;3;0;dev.openroot@live.com;3;11;17;64;readonly;";
	local _mixedformmessage="Please enter the required information";
	local _mixedformtitle="Sample Mixedform";
	_dialog._mixedform "$_mixedformitems" "$_mixedformmessage" "$_mixedformtitle" "11" "34" "3";
	_dialog._message "$_dialog_mixedform_result" "Mixedform returned values";

	# _dialog._inputbox
	local _inputboxinit="Hello there!";
	local _inputboxmessage="Please enter a message";
	local _inputboxtitle="Sample inputbox";
	_dialog._inputbox "$_inputboxinit" "$_inputboxmessage" "$_inputboxtitle" "8" "34";
	_dialog._message "$_dialog_inputbox_result" "Inputbox returned values";
}

# endregion

# region execute

_construct;

# endregion
