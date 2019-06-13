# read a file to string
file_data = "$(<"file")"

# read a file to an array by line
# if Bash version<4
IFS = $'\n' read -d "" -ra file_data < "file"
# if Bash version>=4
mapfile -t file_data < "file"
