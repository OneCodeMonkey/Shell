split() {
	# Usage: split "string" "delimiter"
	IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
	printf '%s\n' "${arr[@]}"
}