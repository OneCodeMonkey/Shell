regex() {
	# Usage: regex "string" "regex"
	[[ $1 =~ $2 ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}