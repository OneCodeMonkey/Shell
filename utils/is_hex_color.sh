is_hex_color() {
	if [[ $1 =~ ^(#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3}))$ ]]; then
		printf '%s\n' "${BASH_REMATCH[1]}"
	else
		printf '%s\n' "error: $1 is an invalid color!"
		return 1
	fi
}
read -r color
is_hex_color "$color" || color='#FFFFFF'