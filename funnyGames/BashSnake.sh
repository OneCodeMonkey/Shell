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

move_and_draw() {
	echo -ne "\e[${1};${2}H$3"
}

draw_board() {
	move_and_draw 1 1 "$border_color+$no_color"
	for((i = 2; i <= width + 1; i++)); do
		move_and_draw 1 $i "$border_color-$no_color"
	done
	move_and_draw 1 $((width - 2)) "$border_color-$no_color"
	echo

	for((i = 0; i < height; i++)); do
		move_and_draw $((i + 2)) 1 "$border_color|$no_color"
		eval echo -en "\"${arr$i[*]}\""
		echo -e "$border_color|$no_color"
	done

	move_and_draw $((height + 2)) 1 "$border_color+$no_color"
	for((i = 2; i <= width+1 ; i++)); do
		move_and_draw $((height + 2)) $i "$border_color-$no_color"
	done
	move_and_draw $((height + 2)) $((width + 2)) "$border_color+$no_color"
	echo
}

# set the snake's initial state
init_snake() {
	alive = 0
	length = 10
	direction = 0
	delta_dir = -1

	head_r = $((height / 2 - 2))
	head_c = $((width / 2))

	body = ''
	for((i = 0; i < length - 1; i++)); do
		body = "1$body"
	done
}