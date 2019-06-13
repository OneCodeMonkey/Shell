# get the first N lines of a file
head() {
	# Usage: head "n" "file"
	mapfile -tn "$1" line < "$2"
	printf '%s\n' "${line[@]}"
}