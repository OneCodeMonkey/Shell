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
