# get base-name of a path
basename() {
	# Usage: basename "path"
	: "${1%/}"
	printf '%s\n' "${_##*/}"
}
# >> basename ~/images/a.jpg
# >> a.jpg
# >> basename ~/images/
# >> images