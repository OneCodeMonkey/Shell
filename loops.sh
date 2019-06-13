# loop over a range of numbers
# loop from 0-100(no variable support)
for i in {0..100}; do
	printf '%s\n' "$i"
done

# loop over a variable range of numbers
# loop from 0-VAR
VAR=50
for (( i = 0; i <= VAR; i++)); do
	printf '%s\n' "$i"
done

# loop over an array
arr = (apples oranges tomatoes)
# just elements
for element in "${arr[@]}"; do
	printf '%s\n' "$element"
done

# loop over an array with an index
arr = (apples oranges tomatoes)
# elements and index.
for i in "${!arr[@]}"; do
	printf '%s\n' "${arr[i]}"
done
# another alternative
for (( i = 0; i < ${#arr[@]}; i++)); do
	printf '%s\n' "${arr[i]}"
done

# loop over the contents of a file
while read -r line; do
	printf '%s\n' "$line"
done
