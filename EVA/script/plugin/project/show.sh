#!/bin/bash

# pwd: BASE_PATH/eval/proj1-p2
# param: MSE-0000 MSE-0001 MSE-0002 ..

param=($@)
[ $# -eq 0 ] && param=(`ls -d */ 2>/dev/null`)

curProj=$(basename "`pwd`")

for((i=0;i<${#param[*]};i++)); do
	dir=${param[i]}
	[ ! -d "$dir" ] && continue;

	echo -en "$MACHINE $curProj "
	p=${dir%/}
	if [ -f $p/param ]; then
		echo -n $p "`head -n1 $p/param`"
	else
		echo -n $p
	fi
	if [ -d $p/log ]; then
		if [ -f $p/*.sum ]; then
			echo ''
		else
			echo -e "\t[incomplete]"
		fi
	else
		echo -e "\t[pending]"
	fi
done
