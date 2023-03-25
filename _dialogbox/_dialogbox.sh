#!/bin/bash
# Name: _dialogbox.sh
# Purpose: GUI Dialogbox bash script
# ----------------------------------

# region script requires

# current directory (relative)
_const_currentdir=$(builtin cd .; pwd);

# dialogbox library
source $_const_currentdir/_library.sh;

# regionend

# region function

trap _dialogbox._trap SIGINT;
function _dialogbox._trap() {
	exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _dialogbox._construct() {
	_dialogbox._app;
}

function _dialogbox._app() {
	# array of dialog functions
	local _dialogfunctions=(
		"_dialog._message"
		"_dialog._menu"
		"_dialog._form"
		"_dialog._mixedform"
		"_dialog._inputbox"
		"_dialog._checklist"
		"_dialog._radiolist"
		"_dialog._yesno"
		"_dialog._fselect"
		"_dialog._timebox"
		"_dialog._calendar"
		"_dialog._prgbox"
	);
	_dialog._menu._labelgenerator "${_dialogfunctions[@]}";
	local _dialogfunctionslabels=$_dialog_menu_labels;

	# loop infinite for dialog function(s) menu
	while true;
	do
		_dialog._menu "$_dialogfunctionslabels" "Select a function to execute" "List of dialog function" "20" "45" "12";
		
		if [[ $_dialog_menu_result == -1 ]];
		then
			break;
		else
			local _selectedlabel="${_dialogfunctions[$_dialog_menu_result-1]}";
			_dialogbox._samplingfunction "$_selectedlabel";
		fi
	done
}

function _dialogbox._samplingfunction() {
	local _selecteddialogfunction=$1;
	case $_selecteddialogfunction in
		"_dialog._message")
			# _dialog._message
			local _messagestring="Hello\n\"World\"!";
			local _messagetitle="Sample Message";
			_dialog._message "$_messagestring" "$_messagetitle" "6" "28";
		;;

		"_dialog._menu")
			# _dialog._menu
			local _menuitems=(
				"App for test buddies"
				"Book of jealous intelligent(s)"
				"Copy of tutorial(s)"
			);
			_dialog._menu._labelgenerator "${_menuitems[@]}";
			local _menuitemslabels=$_dialog_menu_labels;

			_dialog._menu "$_menuitemslabels" "List of menu items" "Sample Menu" "11" "45" "3";
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

		"_dialog._checklist")
			# _dialog._checklist
			local _checklistitems=("potato" "on" "carrot" "off" "grape" "on" "cabbage" "on");
			_dialog._checklist._labelgenerator "${_checklistitems[@]}";
			local _checklistitemslabels=$_dialog_checklist_labels;

			_dialog._checklist "$_checklistitemslabels" "List of checklist items" "Sample Checklist" "11" "45" "3";
			if [[ $_dialog_checklist_result != -1 ]];
			then
				_dialog._newlinedelimitedstringtoarray "$_dialog_checklist_result";
				local _countselected=${#_dialog_array[@]};

				_selectedlabels="";
				for _i in "${_dialog_array[@]}";
				do
					_dialog._checklist._getlabelbytag "$_checklistitemslabels" "$_i";
					_selectedlabels+="$_dialog_checklist_labelbytag\n";
				done
				_dialog._message "$_selectedlabels" "Selected labels (total count: $_countselected)" "" "40";
			fi
		;;

		"_dialog._radiolist")
			# _dialog._radiolist
			local _radiolistitems=("Fahrenheit" "off" "Celcius" "off" "Kelvin" "on" "Rankine" "off");
			_dialog._radiolist._labelgenerator "${_radiolistitems[@]}";
			local _radiolistitemslabels=$_dialog_radiolist_labels;

			_dialog._radiolist "$_radiolistitemslabels" "List of radiolist items" "Sample Radiolist" "11" "45" "3";
			if [[ $_dialog_radiolist_result != -1 ]];
			then
				_dialog._radiolist._getlabelbytag "$_radiolistitemslabels" "$_dialog_radiolist_result";
				_dialog._message "$_dialog_radiolist_labelbytag" "Radio selected";
			fi
		;;

		"_dialog._yesno")
			# _dialog._yesno
			_dialog._yesno "Hey Geek,\n\ndo you want to continue\nwith current session?" "Sample Yesno" "8" "34";
			if [[ $_dialog_yesno_result == 0 ]]; then _dialog_yesno_result="yes"; fi;
			if [[ $_dialog_yesno_result == 1 ]]; then _dialog_yesno_result="no"; fi;
			if [[ $_dialog_yesno_result == 255 ]]; then _dialog_yesno_result="escape"; fi;
			_dialog._message "$_dialog_yesno_result" "Yesno returned value";
		;;

		"_dialog._fselect")
			# _dialog._fselect
			_dialog._fselect "../_coffee/_coffee.sh" "Sample Fileselector" "" "50" ;
			_dialog._message "$_dialog_fselect_result" "Fselect returned value";
		;;

		"_dialog._calendar")
			# _dialog._calendar
			_dialog._calendar "9" "8" "1988" "Date of Birth" "Sample Calendar";
			_dialog._message "$_dialog_calendar_result" "Calendar returned value (dd/mm/yyyy)" "" "40";
		;;

		"_dialog._timebox")
			# _dialog._timebox
			_dialog._timebox "0" "4" "28" "Time of Birth" "Sample Timebox";
			_dialog._message "$_dialog_timebox_result" "Timebox returned value (hh:mm:ss)" "" "40";
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
}

# endregion

# region execute

_dialogbox._construct;

# endregion
