#!/bin/bash
# Name: _math.sh
# Purpose: [ module ] math bash script
# ------------------------------------

# region function

# param1 = operand first ;numeric
# param2 = arithmetic operation ;character
# param3 = operand second ;numeric
# param4 = scale (max numbers of decimal part) ;numeric
# return = result of arithmetic operation ;numeric
# sample usage 1: <var0> = $(_arith $<var1> '<+|-|*|/|%>' $<var2> $<var3>)
function _math._arith () {
	local _value1=$1;
	local _operation=$2;
	local _value2=$3;
	local _scale=$4;
	local _result=`bc -l <<< "scale=$_scale; $_value1 $_operation $_value2"`;
	echo "$_result";
}

# endregion
