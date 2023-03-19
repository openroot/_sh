#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing  bash script
# ---------------------------------

# region function

trap _trap SIGINT;
function _trap() {
        exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _construct() {
        _arg1=$1;

        # current directory (relative)
        _fs_const_dir=`dirname $0`;

        # json file having channel enlist
        _channellist_json_file="$_fs_const_dir/packs/channel-list.json";

        # invoke app functionality(s)
        _app;
}

function _app() {
        # trying taking channel selection from passed argument from console
        if ! [ -z $_arg1 ]
        then
                printf "Passed argument: $_arg1\n";
        fi

        # total count of enlisted channels
        _count_enlist=`jq '. | length' $_channellist_json_file`;
        printf "Total enlisted channels: $_count_enlist\n";

        # sample jq query
        jq '.[] 
        select(.package=="a-la-carte") |
        .category,.package,.name,.cno,.price' $_channellist_json_file;
}

# endregion

# region execute

_construct $1;#!/bin/bash
# Name: _d2h.sh
# Purpose: d2h listing  bash script
# ---------------------------------

# region function

trap _trap SIGINT;
function _trap() {
        exit; # exit the app (on next run) pressing <<ctrl><c>>
}

function _construct() {
        _arg1=$1;

        # current directory (relative)
        _fs_const_dir=`dirname $0`;

        # json file having channel enlist
        _channellist_json_file="$_fs_const_dir/packs/channel-list.json";

        # invoke app functionality(s)
        _app;
}

function _app() {
        # trying taking channel selection from passed argument from console
        if ! [ -z $_arg1 ]
        then
                printf "Passed argument: $_arg1\n";
        fi

        # total count of enlisted channels
        _count_enlist=`jq '. | length' $_channellist_json_file`;
        printf "Total enlisted channels: $_count_enlist\n";

        # sample jq query
        #jq '.[] |
        #select(.package=="a-la-carte") |
        #.category,.package,.name,.cno,.price' $_channellist_json_file;

        _showmsg "Hello\nWorld!" "Channel Details";
}

function _showmsg() {
        local _message=$1;
        local _title=$2;
        local _height=9;
        local _width=32;
        if ! [ -z $3 ]
        then
                _height=$3;
        fi
        if ! [ -z $4 ]
        then
                _width=$4;
        fi

        dialog --clear --erase-on-exit \
        --title "$_title" --msgbox "$_message" $_height $_width;
}

# endregion

# region execute

_construct $1;

# endregion

# endregion
