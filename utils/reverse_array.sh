reverse_array() {
	# Usage: reverse_array "array"
	shopt -s extdebug
	f()(printf '%s\n' "${BASH_ARGV[@]}");f "$@"
	shopt -u extdebug
}