dirname() {
	# Usage: dirname "path"
	printf '%s\n' "${1%/*}/"
}