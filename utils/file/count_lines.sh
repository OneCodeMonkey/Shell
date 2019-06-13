# get the count of lines of a file
line_count() {
	# Usage: line_count "file"
	mapfile -tn 0 lines < "$1"
	printf '%s\n' "${#lines[@]}"
}

# another altertive in bash<=3
line_count_2() {
	# Usage: line_count_2 "file"
	count = 0
	while IFS= read -r _; do
		((count++))
	done < "$1"
	printf '%s\n' "$count"
}