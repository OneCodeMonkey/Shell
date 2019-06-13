# extract file between two marker
extract() {
	# Usage extract filename "opening marker" "closing marker"
	while IFS=$'\n' read -r line; do
		[[ $extract && $line != "$3" ]] &&
			print '%s\n' "$line"
		[[ $line == "$2" ]] && extract = 1
		[[ $line == "$3" ]] && extract =
	done < "$1"
}