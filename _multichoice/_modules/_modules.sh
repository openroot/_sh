#!/bin/bash
# Name: _math.sh
# Purpose: [ module ] modules bash script
# ---------------------------------------

# region function

function _fs._samplefunction () {
	local _operand1=100.12;
	local _operand2=3;
	local _scale=3;
	local _result=$(_math._arith $(_math._arith $_operand1 '*' $_operand2 $_scale) '/' 20 3);
	echo "say sample ~math arithmetic operation :: ($_operand1 * $_operand2) / 20 = $_result";
}

function _fs._currentdatetime () {
	echo "current date time: `_fs._datetime`";
}

# endregion
