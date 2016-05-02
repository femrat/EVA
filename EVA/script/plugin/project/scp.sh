#!/bin/bash

# pwd: BASE_PATH/eval/proj1-p2
# param: MSE-1 MSE-2 ... DEST

if [ $# -eq 0 ]; then
	echo "usage: eva scp params ... DEST"
	echo "If params are omitted, all params are assumed"
	echo "Example: assume we have a benchmark set called M, then we can execute \`eva scp M-0000 M-0001 DEST'"
	exit 1
fi

paramList=($@)

paramEndPos=${#paramList[*]}
paramEndPos=$((paramEndPos-1))
destDir=${paramList[paramEndPos]}

if [ $paramEndPos -eq 0 ]; then
	paramList=(`ls -d */ 2>/dev/null`)
	paramEndPos=${#paramList[*]}
fi

fileList=()
for ((pos=0; pos<paramEndPos; pos++)); do
	dir="${paramList[pos]}"
	[ ! -d "$dir" ] && continue
	l=(`find "$dir" -name '*.sum'`)
	if [ ${#l[*]} -gt 0 ]; then
		fileList=(${fileList[*]} ${l[*]})
	else
		echo "WARNING: $dir has not been collected, skipped."
	fi
done

if [ ${#fileList[*]} -eq 0 ]; then
	echo "Nothing to copy"
	exit
fi

echo -n "Copy ${#fileList[*]} files to $destDir, yes/view/no? [y/v/N] "

while :; do
	read p
	case $p in
		'y')
			if echo "$destDir" | grep ':' >/dev/null; then
				scp -Cv ${fileList[*]} $destDir
				echo "Executing scp done"
			else
				cp -v ${fileList[*]} $destDir
				echo "Executing cp done"
			fi
			exit 0
			;;
		'v'|'V')
			echo "${fileList[*]}"
			echo -n "Copy ${#fileList[*]} files to $destDir, yes/view/no? [y/v/N] "
			;;
		*)
			echo "Cancelled"
			exit 0
			;;
	esac
done

