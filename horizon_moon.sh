#!/bin/zsh

local range="4d"            #default
local visible="0"             #default
local positional=()
local debug="false"
local usage=(
    "horizon_moon.sh [-h|--help] [-d|--debug] [-v|--visible <is moon visible|default('0')>] [-r|--range <number of days|default('4d')>]"
)

opterr() { echo >&2 "horizon_moon: Unknown option '$1'" }

while (( $# )); do
    case $1 in
        --)                 shift; positional+=("${@[@]}"); break  ;;
        -h|--help)          printf "%s\n" $usage && return         ;;
        -d|--debug)         debug="true"                           ;;
        -v|--visible)       shift; visible=$1                      ;;
        -r|--range)         shift; range=$1                        ;;
        -*)                 opterr $1 && return 2                  ;;
        *)                  positional+=("${@[@]}"); break         ;;
    esac
    shift
done

startDate=`date "+%Y-%m-%d"`
endDate=`date -v+$range "+%Y-%m-%d"`
strQuantities="'4,10'"
elevCut=$visible

if [[ $debug == "true" ]] 
then
    echo "Debug Info"
    echo "--------------------------------"
    echo "Start Date: ${startDate}"
    echo "End Date: ${endDate}"
    echo "Quantities: ${strQuantities}"
    echo "Visible: ${elevCut}"
    
    echo "\n"
    echo 'Press any key to continue...'; read -k1 -s

    curl -v -s https://ssd.jpl.nasa.gov/api/horizons.api\?format\=text\&COMMAND\='301'\&OBJ_DATA\='NO'\&MAKE_EPHEM\='YES'\&EPHEM_TYPE\='OBSERVER'\&CENTER\='759'\&START_TIME\=$startDate\&STOP_TIME\=$endDate\&TIME_ZONE\='-6'\&STEP_SIZE\='1h'\&ELEV_CUT\=$elevCut\&QUANTITIES\="$strQuantities"
else
    curl -s https://ssd.jpl.nasa.gov/api/horizons.api\?format\=text\&COMMAND\='301'\&OBJ_DATA\='NO'\&MAKE_EPHEM\='YES'\&EPHEM_TYPE\='OBSERVER'\&CENTER\='759'\&START_TIME\=$startDate\&STOP_TIME\=$endDate\&TIME_ZONE\='-6'\&STEP_SIZE\='1h'\&ELEV_CUT\=$elevCut\&QUANTITIES\="$strQuantities"
fi
