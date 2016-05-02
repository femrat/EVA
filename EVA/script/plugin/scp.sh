#!/bin/bash

# pwd: BASE_PATH/eval/
# param: ALG1 ALG2 ... DEST

if [ $# -eq 0 ]; then
	echo "usage: eva scp projects ... DEST"
	echo "All params inside the projects will be copied to DEST"
	exit 1
fi

paramList=($@)

paramEndPos=${#paramList[*]}
paramEndPos=$((paramEndPos-1))
destDir=`readlink -f "${paramList[paramEndPos]}"` # get the absolute path, since we will change directory later

if [ $paramEndPos -eq 0 ]; then
	echo "No project is given"
	exit
fi

for ((pos=0; pos<paramEndPos; pos++)); do
	dir="${paramList[pos]}"
	[ ! -d "$dir" ] && continue
	cd $dir
	echo "Entering $dir"
	eva scp $destDir
	cd ..
done

