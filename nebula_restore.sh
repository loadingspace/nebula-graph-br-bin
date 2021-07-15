#!/bin/sh

echo $2

dirs=`find / | grep "^.*$1$"`
dir_array=(${dirs//,/ }) 

echo -e "\033[32m开始覆盖数据文件...\033[0m"
for dir in ${dir_array[@]}
do
	echo -e "cover dir: $dir"
	origin_data=`echo "$dir" | awk -F "/checkpoints/$1" '{print $1}'`
	if [ -d "$origin_data" ]
	then
		rm -rf "$origin_data/data"
		cp -r "$dir/data" $origin_data

		rm -rf "$origin_data/wal"
		cp -r "$dir/wal" $origin_data
	fi
done 

echo -e "\033[32m执行重启命令...\033[0m"
echo -e "$2"
bash $2
