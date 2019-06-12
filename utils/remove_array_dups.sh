# Usage: remove duplicate array elements
remove_array_dups() {
	# Usage: remove_array_dups "array"
	declare -A tmp_array
	for i in "$@"; do
		[[ $i ]] && IFS=" " tmp_array["${i:- }"]=1
	done

	printf '%s\n' "${!tmp_array[@]}"
}