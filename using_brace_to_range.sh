# for ranges

# print numbers 1-100
echo {1..100}

# print range of floats 1.1 - 1.9
echo 1.{1..9}

# print chars a to z
echo {a..z}
echo {A..Z}

# nesting
echo {A..Z}{0..9}

# print zero-padded numbers 001,002,..,010,011,..,100
echo {01..100}

# change increment amount
# for example, increment by 2
echo {1..10..2}

# array
echo {apples,pears,bananas}

# remove series of file or folder
rm -rf ~/foldername/{a.txt,b.txt,c.txt}