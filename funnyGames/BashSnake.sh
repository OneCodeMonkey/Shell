#!/bin/bash

IFS=''

declare -i height = $(($(tput lines)-5)) width = $(($(tput cols)-2))

# row and column number of head
declare -i head_r head_c tail_r tail_c

declare -i alive
declare -i length
declare body

declare -i direction delta_dir
declare -i score = 0

border_color = "\e[30;43m"
snake_color = "\e[32;42m"
food_color = "\e[34;44m"
text_color = "\e[31;43m"
no_color = "\e[0m"

#signals
SIG_UP = USR1
SIG_RIGHT = USR2
SIG_DOWN = URG
SIG_LEFT = IO
SIG_QUIT = WINCH
SIG_DEAD = HUP

# direction arrays: 0 = up, 1 = right, 2 = down, 3 = left
move_r = ([0]=-1 [1]=0 [2]=1 [3]=0)
move_c = ([0]=0 [1]=1 [2]=0 [3]=-1)

init_game() {
	clear
	echo -ne "\e[?251"
	stty -echo
	for((i = 0; i < height; i++)); do
		for((j = 0; j < width; j++)); do
			eval "arr$i[$j]=' '"
		done
	done
}
