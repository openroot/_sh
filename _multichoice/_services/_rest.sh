#!/bin/bash
# Name: _rest.sh
# Purpose: [ service ] rest bash script
# -------------------------------------

# region function

# function to invoke rest api
_fs_restapiinvoke_lastresult="";
function _fs._restapiinvoke () {
	# entering past 1st time; printing the last result till current await request completed; this if segment only needed if fresh screen requested
	if ! [[ $_fs_autooperation_freshscreen == "n" ]];
	then
		if [[ $_fs_restapiinvoke_lastresult != "" ]];
		then
			clear;
			echo "Response from server: ";
			echo -e "$_fs_restapiinvoke_lastresult"; echo;
		fi
	fi

	#result=`curl --silent GET --header "Accept: */*" "https://corona-virus-stats.herokuapp.com/api/v1/cases/general-stats"`;
	#result=`curl -# GET --header "Accept: */*" "https://corona-virus-stats.herokuapp.com/api/v1/cases/general-stats"`;
	result=`curl -X GET --header "Accept: */*" "https://corona-virus-stats.herokuapp.com/api/v1/cases/general-stats"`;
	
	_formattedoutput=$result"\n\n\t""date time = "`fs.datetime`;

	# entering past 1st time; this if segment only needed if fresh screen requested
	if ! [[ $_fs_autooperation_freshscreen == "n" ]];
	then
		if [[ $_fs_restapiinvoke_lastresult != "" ]];
		then
			clear;
		fi
	fi

	echo "Response from server: ";
	echo -e $_formattedoutput;
	_fs_restapiinvoke_lastresult=$_formattedoutput;
}

# endregion
