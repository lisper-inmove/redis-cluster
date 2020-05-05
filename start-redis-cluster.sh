#!/bin/bash

workdir="`pwd`/workdir"

function start() {
    input=$workdir/config_file.conf
    while IFS= read -r line
    do
        echo "start redis cluster with config file $line"
        redis-server $line
    done < $input
}

function end() {
    input=$workdir/config_pid.conf
    while IFS= read -r line
    do
        while IFS= read -r port
        do
            echo "stop redis cluster with port: $port"
            kill -9 $port
            # redis-cli -p $port shutdown nosave
        done < $line
    done < $input
}

function help() {
    echo "redis cluster scripts usage"
    echo "-w,--workdir"
    echo "-s,--start"
    echo "-e,--end"
}


while (( "$#" ));
do
    case "$1" in
        -w|--workdir)
            workdir=$2
            shift
            ;;
        -s|--start)
            start $workdir
            shift
            ;;
        -e|--stop)
            end $workdir
            shift
            ;;
        -h|--help)
            help
            shift
            ;;
        *)
            shift
            ;;
    esac
done
