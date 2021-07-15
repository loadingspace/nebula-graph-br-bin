#!/bin/sh

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

NEBULA_CONSOLE_DOWNLOAD="https://github.com/vesoft-inc/nebula-console/archive/refs/tags/v2.0.1.zip"

NEBULA_CONSOLE_DIR="$SCRIPT_DIR/nebula-console"

NEBULA_CONSOLE_FILE="$NEBULA_CONSOLE_DIR/nebula-console"

if [ ! -d "$NEBULA_CONSOLE_DIR" ]
then
	wget -P $SCRIPT_DIR $NEBULA_CONSOLE_DOWNLOAD -O 'nebula-console.zip'
	unzip -u -d "$SCRIPT_DIR/" "$SCRIPT_DIR/nebula-console.zip" 
	mv "$SCRIPT_DIR/nebula-console-2.0.1" "$SCRIPT_DIR/nebula-console"
	rm -f "$SCRIPT_DIR/nebula-console.zip"
	if [ ! -d "$NEBULA_CONSOLE_DIR" ]
	then
		echo -e "\033[31m download nebula-console fail! \033[0m"
		exit 1
	fi	
fi

if [ ! -f "$NEBULA_CONSOLE_FILE" ]
then
	echo -e "\033[33m install [nebula-console] \033[0m"
	cd $NEBULA_CONSOLE_DIR
	make
	if [ ! -f "$NEBULA_CONSOLE_FILE" ]
	then
		echo -e "\033[31m make nebula-console fail! \033[0m"
		exit 1
	fi	
fi

echo -e "\033[32mnebula-consle is ok!\033[0m"


function backup(){
	local result=$($NEBULA_CONSOLE_FILE -addr $1 -port $2 -u $3 -p $4 -e "create snapshot")
	if [[ "$(echo "$result" | grep "Execution succeeded")" != "" ]]
	then
    	echo -e "\033[32m backup success! \033[0m"
	else
    	echo -e "\033[31m backup fail or timeout! \033[0m"
	fi
}


function delete_backup(){
	if [[ "$(echo "$(show $1 $2 $3 $4)" | grep $5)" == "" ]]
	then
    	echo -e "\033[31m not find snapshot!  [$snapshot_name] \033[0m"
    	exit 1
	fi
	local result=$($NEBULA_CONSOLE_FILE -addr $1 -port $2 -u $3 -p $4 -e "drop snapshot $5")
	if [[ "$(echo "$result" | grep "Execution succeeded")" != "" ]]
	then
    	echo -e "\033[32m delete success! \033[0m"
	else
    	echo -e "\033[31m delete fail or timeout! \033[0m"
	fi
}


function restore(){
	echo $6
	local snapshot_list=$(show $1 $2 $3 $4)
	echo -e "$snapshot_list\n"
	if [[ "$(echo "$snapshot_list" | grep $5)" == "" ]]
	then
    	echo -e "\033[31m not find snapshot!  [$snapshot_name] \033[0m"
    	exit 1
	fi
	local addrs=`echo "$snapshot_list" | grep $5 | awk -F '   ' '{print $4}'`
	local addr_array=(${addrs//,/ }) 
	for addr in ${addr_array[@]}
	do
		local host=`echo $addr | awk -F ':' '{print $1}'`
		echo -e "\033[32m正在处理 $host\033[0m"
		echo "ssh $host 'bash -s' < $SCRIPT_DIR/nebula_restore.sh $5 \"$6\""
		ssh $host 'bash -s' < $SCRIPT_DIR/nebula_restore.sh $5 "\"$6\""
	done 
}


function show(){
	local result=$($NEBULA_CONSOLE_FILE -addr $1 -port $2 -u $3 -p $4 -e "show snapshots")
	echo -e "\nresult:\n"
	echo "$result" | grep "SNAPSHOT" | sed "s/\"//g"  | sed "s/[ ]//g" | sed "s/|/   /g"
	echo -e "\nfinish!\n"
}


ACTION=$1

case $ACTION in
	backup)
		backup $2 $3 $4 $5
		;;
	delete)
		delete_backup $2 $3 $4 $5 $6
		;;
	restore)
		echo $7
		restore $2 $3 $4 $5 $6 "$7"
		;;
	show)
		show $2 $3 $4 $5
		;;
	*)
		echo -e "\n 用法:\n\n    备份\n    backup [nebulahost] [port] [user] [password]\n\n    删除备份\n    delete [nebulahost] [port] [user] [password] [snapshotname]\n\n    回滚到某个版本\n    restore [nebulahost] [port] [user] [password] [snapshotname] [restartnebulacommand]\n\n    查看所有备份\n    show [nebulahost] [port] [user] [password]\n"
		exit 1
esac
