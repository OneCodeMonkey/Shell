#! /bin/bash

# travel through all input arguments
echo -e "Now total arguments is $#.\nAnd every one of them is the following:"
count=1;step=1
while (($# > 0))
do
echo -e "Argument $count : $1"
count=`expr $count + $step`
shift
done
