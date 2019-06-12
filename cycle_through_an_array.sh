arr=(a b c d)

cycle() {
	printf '%s ' "${arr[${i:=0}]}"
	((i=i>=${#arr[@]}-1?0:++i))
}