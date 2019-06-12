urldecode() {
	# Usage: urldecode "https%3A%2F%2Fgithub.com"
	# https://github.com
	: "${1//+/ }"
	printf '%b\n' "${_//%/\\x}"
}