#!/bin/bash
# Name: _multichoice.sh
# Purpose: [ module ] _multichoice bash script
# --------------------------------------------

# region script requires

_fs_const_dir=`dirname $0`;
source ${_fs_const_dir}/_modules/_modules.sh;
source ${_fs_const_dir}/_modules/_helper.sh;
source ${_fs_const_dir}/_modules/_math.sh;
source ${_fs_const_dir}/_services/_rest.sh;

# endregion

# region input

echo -e "Press [n] anytime exit app"; echo;

# endregion

# region execute

while : ;
do
	if [[ $_fs_autooperation_auto == 0 ]];
	then
		read -rp "Please enter option for operation [[ 0 | a/A | b/B | c/C | n/no ]]: " "_operation";
		echo -e "Entered option = $_operation"; echo;
	else
		sleep $_fs_autooperation_delayinsec;
		if ! [[ $_fs_autooperation_freshscreen == "n" ]];
		then
			clear;
		fi
	fi

    case $_operation in

	0)
		clear; # clears the screen
	;;

	a)
		_fs._samplefunction;
	;;
	A)
		_fs._samplefunction;
		_fs._autooperation;
	;;

	b)
		_fs._currentdatetime;
	;;
	B)
		_fs._currentdatetime;
		_fs._autooperation;
	;;

	c)
		_fs._restapiinvoke;
	;;
	C)
		_fs._restapiinvoke;
		_fs._autooperation;
	;;

	#d)
	#	sqlite3 /media/devop/0disk--1set/--system/--git/--code/github/--sqllitedatabases/--d2hinfo.db <<END_SQL
	#	.timeout 2000
	#	SELECT * FROM --stream;
	#	END_SQL
	#;;

	n | "no")
		break; # on selection exit the app
	;;

	*)
		echo "[unknown] option entered";
	;;
	esac

	echo;

	# following code ; only & only if needed an extra ask for breaking the loop
	#read -rp "Want to repeat [any key/n]: " "cont"
    #[[ $cont != "n" ]] || break
done

# endregion

# region exit

echo "App executed successfully.";
exit;

# endregion
