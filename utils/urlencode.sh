urlencode() {
	# Usage: urlencode "https://github.com"
	# https%3A%2F%2Fgithub.com
	local LC_ALL=C
	for(( i = 0; i < ${#1}; i++ )); do
		: "${1:i:1}"
		case "$_" in
			[a-zA-Z0-9.~_-])
				printf '%s' "$_"
			;;

			*)
				printf '%%%02X' "'$_"
			;;
		esac
	done
	printf '\n'
}