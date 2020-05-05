#!/bin/bash

function create_dir_if_not_exists() {
    dir=$1
    if [ ! -d $dir ]
    then
        mkdir -p $dir
    fi
}

function create_file_if_not_exists() {
    file=$1
    if [ ! -f $file ]
    then
        # echo "$file does not exists"
        touch $file
    fi
}

function generate_config_file() {
    # dir ./
    # port 6379
    # pidfile /var/run/redis_6379.pid
    # logfile ""
     config_dir=$1
     db_dir=$2
     log_dir=$3
     port=$4
     config_template="config-template.conf"

     config_file="$config_dir/${port}.conf"
     cp $config_template $config_dir/${port}.conf
     echo "port $port" >> $config_file
     echo "dir $db_dir" >> $config_file
     echo "pidfile $config_dir/${port}.pid" >> $config_file
     echo "logfile $log_dir/${port}.log" >> $config_file
     echo "cluster-config-file $config_dir/${port}.cluster.conf" >> $config_file
     echo "cluster-enabled yes">> $config_file
     echo "cluster-node-timeout 5000" >> $config_file

     # record config file path in the file
     echo $config_file >> $workdir/config_file.conf
     echo $config_dir/${port}.pid >> $workdir/config_pid.conf
}


workdir="/root/code/redis-cluster/workdir"
create_dir_if_not_exists $workdir
config_path="${workdir}/configs"
create_dir_if_not_exists $config_path
log_path="${workdir}/logs"
create_dir_if_not_exists $log_path
db_path="${workdir}/db"
create_dir_if_not_exists $db_path

ports=$@

for port in $ports
do
    config_dir="$config_path/$port"
    log_dir="$log_path/$port"
    db_dir="$db_path/$port"

    create_dir_if_not_exists $config_dir
    create_dir_if_not_exists $log_dir
    create_dir_if_not_exists $db_dir

    generate_config_file $config_dir $db_dir $log_dir $port

done
