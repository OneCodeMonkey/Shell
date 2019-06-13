# loop over a range of numbers
# loop from 0-100(no variable support)
for i in {0..100}; do
	printf '%s\n' "$i"
done

# loop over a variable range of numbers
# loop from 0-VAR
VAR=50
for(( i = 0; i <= VAR; i++)); do
	printf '%s\n' "$i"
done
