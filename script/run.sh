#!/bin/bash

if [ $# -ne 4 ]; then
	echo "This is the part of EVA"
	echo "Don't run this separately"
	exit 1
fi

idx="$1"
cnt="$2"
out="$3"
saveto="$4"

echo "`date` [ $((1+idx)) / $cnt ] $saveto"

t=$({ time $out &> $saveto; } 2>&1 | tr '\n' '\t')

tt="`date`|$out &> $saveto;$t"

{
	flock -x 233

	echo "$tt" >> "$EVALOGPATH/cmd.log" # global cmdlog, EVALOGPATH is exported by eva

	if [ "$saveto" != "/dev/null" ]; then
		echo "$tt" >> "$(dirname "$saveto")/../cmd.log" # ~/EVA/eval/ALG_1-p2/M-1234/log/../cmd.log
		chmod -w "$saveto"
	fi

} 233>$BASE_PATH/script/.loglock
