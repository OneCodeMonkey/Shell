lstrip() {
	# Usage: lstrip "string" "pattern"
	printf '%s\n' "${1##$2}"
}