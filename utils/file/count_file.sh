# count files or directories in directory
count_file_or_dir() {
	# Usage: count_file_or_dir /path/to/dir/*
	# 		 count_file_or_dir /path/to/dir/*/
	printf '%s\n' "$#"
}