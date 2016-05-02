#!/bin/bash

# pwd: BAES_PATH/eval
# param: out para

if [ "$#" -ne 2 ]; then
	echo "Usage: eva new out para"
	exit 1
fi

if [ ! -x $1 -o ! -f $1 ]; then
	echo "$1 is not an executable file"
	exit 2
fi

dir="$(basename $1 .out)-p$2"

mkdir -v "$dir"

scp $1 $dir

chmod -w $dir/*
