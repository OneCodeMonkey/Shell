trim_string() {
	# Usage: trim_string " example  string   "
	# >> example  string
	: "${1#"${1%%[![:space:]]*}"}"
	: "${_%"${_##*[![:space:]]}"}"
	printf '%s\n' "$_"
}

trim_all() {
	# Usage: trim_all "  example   string    "
	# >> example string
	set -f
	set -- $*
	printf '%s\n' "$*"
	set +f
}