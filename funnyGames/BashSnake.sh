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

	local p = $((${move_r[1]} * (length - 1)))
	local q = $((${move_c[1]} * (length - 1)))

	tail_r = $((head_r + p))
	tail_c = $((head_c + q))

	eval "arr$head_r[$head_c] = \"${snake_color}o$no_color\""

	prev_r = $head_r
	prev_c = $head_c

	b = $body
	while [ -n "$b" ]; do
		# change in each direction
		local p = ${move_r[$(echo $b | grep -o '^[0-3]')]}
		local q = ${move_c[$(echo $b | grep -o '^[0-3]')]}
		new_r = $((prev_r + p))
		new_c = $((prev_c + q))
		eval "arr$new_r[$new_c]=\"${snake_color}o$no_color\""
		prev_r = $new_r
		prev_c = $new_c
		b = ${b#[0-3]}
	done
}

# judge if the snake died
is_dead() {
	if [ "$1" -lt 0 ] || [ "$1" -ge "$height" ] || [ "$2" -lt 0 ] || [ "$2" -ge "$width" ]; then
		return 0
	fi
	eval "local pos = \${arr$1[$2]}"
	if [ "$pos" == "${snake_color}o$no_color" ]; then
		return 0
	fi
	return 1
}

# generate food at random pos
give_food() {
	local food_r = $((RANDOM % height))
	local fodd_c = $((RANDOM % width))
	eval "local pos=\${arr$food_r[$fodd_c]}"
	while [ "$pos" != ' ' ]; do
		food_r = $((RANDOM % height))
		food_c = $((RANDOM % width))
		eval "pos=\${arr$food_r[$food_c]}"
	done
	eval "arr$food_r[$food_c]=\"$food_color@$no_color\""
}

move_snake() {
	local newhead_r = $((head_r + move_r[direction]))
	local newhead_c = $((head_c + move_c[direction]))
	eval "local pos=\${arr$newhead_r[$newhead_c]}"
	if $(is_head $newhead_r $newhead_c); then
		alive = 1
		return
	fi
	if [ "$pos" == "$food_color@$no_color" ]; then
		length += 1
		eval "arr$newhead_r[$newhead_c]=\"${snake_color}o$no_color\""
		body="$(((direction + 2) % 4))$body"
		head_r = $newhead_r
		head_c = $newhead_c
		score += 1
		give_food;		# 吃了一个，立即生成下一个食物
		return
	fi
	head_r = $newhead_r
	head_c = $newhead_c
	local d = $(echo $body | grep -o '[0-3]$')
	body = "$(((direction + 2) % 4))${body%[0-3]}"
	eval "arr$tail_r[$tail_c]=' '"
	eval "arr$head_r[$head_c]=\"${snake_color}o$no_color\""
	# 新的尾部
	local p = ${move_r[(d+2)%4]}
	local q = ${move_c[(d+2)%4]}
	tail_r = $((tail_r + p))
	tail_c = $((tail_c + q))
}

change_dir() {
	if [ $(((direction + 2)%4)) -ne $1 ]; then
		direction = $1
	fi
	delta_dir = -1
}
