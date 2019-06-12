random_array_element() {
	# Usage random_array_element "array"
	local arr=("$@")
	printf '%s\n' "${arr[RANDOM % $#]}"
}