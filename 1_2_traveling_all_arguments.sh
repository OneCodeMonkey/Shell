#! /bin/bash

# travel through all input arguments
echo -e "Now total arguments is $#.\nAnd every one of them is the following:"
count=1;step=1
while (($# > 0))  # 注意这里循环体，while或者for ，这里的判断体要用两层括号包围来写，因为单层括号会被解释成【提高运算符优先级的普通括号】
do
echo -e "Argument $count : $1"
count=`expr $count + $step`
shift
done
