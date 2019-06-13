# get the count of lines of a file
line_count() {
	# Usage: lines "file"
	mapfile -tn 0 lines < "$1"
	printf '%s\n' "${#lines[@]}"
}