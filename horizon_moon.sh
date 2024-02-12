#!/bin/zsh

range="4d"          #default

while (( $# )); do
    case $1 in
        --)                 shift; positional+=("${@[@]}"); break  ;;
        -h|--help)          printf "%s\n" $usage && return         ;;
        -r|--range)         shift; range=$1                        ;;
        -*)                 opterr $1 && return 2                  ;;
        *)                  positional+=("${@[@]}"); break         ;;
    esac
    shift
done

startDate=`date "+%Y-%m-%d"`
endDate=`date -v+$range "+%Y-%m-%d"`

#echo $startDate
#echo $endDate

curl -s https://ssd.jpl.nasa.gov/api/horizons.api\?format\=text\&COMMAND\='301'\&OBJ_DATA\='NO'\&MAKE_EPHEM\='YES'\&EPHEM_TYPE\='OBSERVER'\&CENTER\='759'\&START_TIME\=$startDate\&STOP_TIME\=$endDate\&TIME_ZONE\='-6'\&STEP_SIZE\='1h'\&QUANTITIES\='10' | less
