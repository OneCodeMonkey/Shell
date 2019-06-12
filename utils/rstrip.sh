rstrip() {
	# Usage: rstrip "string" "pattern"
	printf '%s\n' "${1%%$2}"
}