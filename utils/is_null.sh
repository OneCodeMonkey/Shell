#!/bin/bash
var=$1
if [ ! $var ]; then
	echo "is null"
else
	echo "not null"
fi
