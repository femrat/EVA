#!/bin/bash

# pwd: BAES_PATH/eval
# param: out para

if [ "$#" -ne 2 ]; then
	echo "Usage: eva new <.out> <parallel num>"
	exit 1
fi

out="$1"
para="$2"

if echo "$out" | grep ':' >/dev/null; then
	# remote file
	name=$(basename "${out##*:}")
else
	# local file
	if [ ! -x "$out" -o ! -f "$out" ]; then
		echo "$out not found or is not an executable file"
		exit 2
	fi
	name="$out"
fi

name="$(basename "$name" .out)"

if echo "$name" | grep '[- ]' >/dev/null; then
	echo "\"$name\" is invalid, either \"-\" or space is not allowed"
	exit 3
fi

dir="$name-p$para"

if [ -e "$dir" ]; then
	echo "$dir exists ... nothing to do"
	exit 4
fi

mkdir -v "$dir"

echo "copy $out -> $dir/$(basename "$out")"
if scp $out $dir; then
	chmod -w $dir/*
else
	echo "something wrong. revert ..."
	rm -vr "$dir"
fi
