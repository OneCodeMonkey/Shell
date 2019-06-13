# get the last N lines of a file
tail() {
	# Usage: tail "n" "file"
	mapfile -tn 0 line < "$2"
	printf '%s\n' "${line[@]: -$1}"
}