#!/bin/bash

# pwd: eval/proj-p2/
# argument: [M-1234] [M-2345] ...

ds=($@)

if [ ${#ds[*]} -eq 0 ]; then
	ds=(`ls -d */`)
fi

while [ "$1" ]; do
	if [ ! -d $1/log -o ! -f $1/*.sum ]; then
		echo "$1 is not ready to be decompressed. log directory missing or has not been collected"
		exit 1
	fi
	shift
done

list=(`find ${ds[*]} -name '*.res.xz'`)

if [ ${#list[*]} -eq 0 ]; then
	echo "Nothing to decompress"
	exit 0
fi

echo "`date`: Decompressing ${#list[*]} files"

for ((i=0;i<${#ds[*]};i++)); do
	chmod +w -R ${ds[i]}/log
done

echo ${list[*]} | xargs -n1 -P4 unxz

for ((i=0;i<${#ds[*]};i++)); do
	chmod -w -R ${ds[i]}/log
done

echo "`date`: Decompress done"
