#!/bin/bash
#文件名 image_help.sh
#用途 文件格式转换

if [[ $# -ne 4 && $# -ne 6 && $# -ne 8 ]];
then
	echo "Usage: Incorrect number of parameters"
	exit 2
fi

while [ $# -ne 0 ]
do
	case $1 in
	-source) shift;source_dir=$1;shift;;
	-scale) shift;scale=$1;shift;;
	-percent) shift;percent=$1;shift;;
	-dest) shift;dest_dir=$1;shift;;
	-ext) shift;ext=$1;shift;;
	*) echo Wrong parameters;exit2;;
	esac;
done

for img in $(echo ${source_dir}/*);
do
	source_file=$img
	if [[ -n $ext ]];
	then
		dest_file=${img%.*}.$ext
	else
		dest_file=${img}
	fi

	if [[ -n $dest_dir ]];
	then
		dest_file=${dest_file##*/}
		dest_file="${dest_dir}/${dest_file}"
	fi
	
	if [[ -n $scale ]];
	then
		PARAM="-resize $scale"
	elif [[ -n $percent ]];
	then
		PARAM="-resize $percent%"
	fi

	echo "Processing file: $source_file"
	convert $source_file $PARAM $dest_file
done
	
