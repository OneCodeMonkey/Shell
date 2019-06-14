# assign and access a variable using another variable
hello_world="value"
# create the variable name
var="world"
ref="hello_$var"
# print the value of ref
printf '%s\n' "${!ref}"
# >> value

# name a variable based on another variable
var="world"
declare "hello_$var=value"
printf '%s\n' "$hello_world"
# >> value