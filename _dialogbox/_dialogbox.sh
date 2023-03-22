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
	# array of dialog functions
	local _dialogfunctions=("_dialog._message" "_dialog._menu" "_dialog._form" "_dialog._mixedform" "_dialog._inputbox" "_dialog._prgbox");
	_dialog._menu._labelgeneratorfromarray "${_dialogfunctions[@]}";
	local _numericalordereddialogfunctions=$_dialog_menu_numericalorderedlabels;

	# loop infinite for dialog function(s) menu
	while true;
	do
		_dialog._menu "$_numericalordereddialogfunctions" "Select a function to execute" "List of dialog function" "20" "45" "12";
		
		if [[ $_dialog_menu_result == -1 ]];
		then
			break;
		else
			local _selectedmenulabel="${_dialogfunctions[$_dialog_menu_result-1]}";
			
			case $_selectedmenulabel in
				"_dialog._message")
					# _dialog._message
					local _messagestring="Hello\n\"World\"!";
					local _messagetitle="Sample Message";
					_dialog._message "$_messagestring" "$_messagetitle" "6" "28";
				;;

				"_dialog._menu")
					# _dialog._menu
					local _menuitems=("App for test buddies" "Book of jealous intelligent(s)" "Copy of tutorial(s)");
					_dialog._menu._labelgeneratorfromarray "${_menuitems[@]}";
					local _numericalorderedmenuitems=$_dialog_menu_numericalorderedlabels;

					_dialog._menu "$_numericalorderedmenuitems" "List of menu items" "Sample Menu" "11" "45" "3";
					if [[ $_dialog_menu_result != -1 ]];
					then
						_dialog._message "${_menuitems[$_dialog_menu_result-1]}" "Selection returned";
					fi
				;;

				"_dialog._form")
					# _dialog._form
					local _formitems="Name;1;0;D Tapader;1;11;17;128;Age;2;0;34;2;11;17;3;E-mail ID;3;0;dev.openroot@gmail.com;3;11;17;64;";
					local _formmessage="Please enter the required information";
					local _formtitle="Sample Form";
					_dialog._form "$_formitems" "$_formmessage" "$_formtitle" "11" "34" "3";
					_dialog._message "$_dialog_form_result" "Form returned values";
				;;

				"_dialog._mixedform")
					# _dialog._mixedform
					local _mixedformitems="Name;1;0;devop;1;11;17;128;readonly;Secret;2;0;34;2;11;17;3;hidden;E-mail ID;3;0;dev.openroot@live.com;3;11;17;64;readonly;";
					local _mixedformmessage="Please enter the required information";
					local _mixedformtitle="Sample Mixedform";
					_dialog._mixedform "$_mixedformitems" "$_mixedformmessage" "$_mixedformtitle" "11" "34" "3";
					_dialog._message "$_dialog_mixedform_result" "Mixedform returned values";
				;;

				"_dialog._inputbox")
					# _dialog._inputbox
					local _inputboxinit="Hello there!";
					local _inputboxmessage="Please enter a message";
					local _inputboxtitle="Sample inputbox";
					_dialog._inputbox "$_inputboxinit" "$_inputboxmessage" "$_inputboxtitle" "8" "34";
					_dialog._message "$_dialog_inputbox_result" "Inputbox returned value";
				;;

				"_dialog._prgbox")
					# _dialog._prgbox
					_dialog._inputbox "cd ..; ls;" "Please enter a linux command to execute" "Execute a command" "9";
					if [[ $_dialog_inputbox_result != -1 ]];
					then
						if [[ $_dialog_inputbox_result != "" ]];
						then
							local _command="$_dialog_inputbox_result";
							local _prgboxmessage="Executed command \$$_command";
							local _prgboxtitle="Sample prgbox";
							_dialog._prgbox "$_command" "$_prgboxmessage" "$_prgboxtitle" "20" "50";
						fi
					fi
				;;
				
				*)
				;;
			esac
		fi
	done
}

# endregion

# region execute

_construct;

# endregion
