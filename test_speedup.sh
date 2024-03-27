#!/bin/bash

source ./lib/functions.zsh

_folder_path_icon() {
    if [! command -v md5 &>/dev/null]; then
        local HASH_NUM="$(md5 -s $(pwd) | sed -E 's/[^0-9]//g')"
    fi
    local HASH_NUM="$(md5 -s $(pwd) | sed -E 's/[^0-9]//g')"
    local ICON_INDEX=${HASH_NUM:0:2}
    local ICONS=(
        "📁" "🗄️" "🏆" "💤" "🌀" "♠️" "♥️" "♦️" "♣️" "🃏"
        "🖥️" "💻" "💽" "🖱️" "🖲️" "⌨️" "🖨️" "💾" "📀" "💿"
        "🧅" "🕹️" "👨‍💻" "🐁" "🗜️" "🤖" "🔆" "⚜️" "🔱" "💠"
        "🐻" "🙈" "🙉" "🙊" "🐕" "🐺" "🐈‍⬛" "🦁" "🐯" "🐴"
        "🐇" "🐥" "🦆" "🦢" "🦉" "🦖" "🐉" "🐲" "🕷️" "🕸️"
        "🌍" "🌑" "🌓" "🌖" "🌙" "☀️" "☁️" "🌪️" "❄️" "☄️"
        "🔥" "⛄" "🌊" "💧" "❤️‍🔥" "❤️" "🍔" "🍏" "🍎" "🍒"
        "🍐" "🥕" "🌶️" "🫑" "🍄" "🍕" "🥚" "🍿" "🥡" "☕"
        "🧉" "🧊" "🫐" "🥦" "🍗" "🍇" "🍓" "🥥" "😜" "😎"
        "🍶" "🍾" "🍷" "🍸" "🍹" "🍺" "🍻" "🥂" "🥃" "🥤"
    )

    echo ${ICONS[$ICON_INDEX]}
}

_new_prompt() {
    local off='\033[0m' # Text Reset
    local BLUE="\e[38;5;4m"
    local GREEN="\e[38;5;35m"
    local FG="\e[0;36m"
    local BG="\e[0;46m"
    local GREEN_BG2="\e[2;32;46m"

# ✘
# 
# 
# 【】⟬...⟭...⟫ ❯

    echo -e "${BG} ~/sd/sd/f ${off}${FG}${off}\n${BLUE}❯${off}"
    echo -e "\e[31;47mКрасный текст на белом фоне\e[0m"
}

shorten_path() {
    # Заменяем начальный путь $HOME на ~
    local path="${PWD/#$HOME/~}"
    echo $path
    # Сжимаем путь, оставляя только первые буквы каждого компонента
    local old_IFS="$IFS" # Сохраняем старое значение IFS
    local IFS='/'        # Поле разделителя для массива
    local parts=($path)  # Создаем массив из пути
    local newpath=""
    for part in "${parts[@]}"; do
        # Добавляем только первую букву каждой части, если она не пустая
        if [ -n "$part" ]; then
            newpath+="/${part:0:1}"
        fi
    done
    local IFS="$old_IFS" # Восстанавливаем исходное значение IFS
    # Сохраняем результат в глобальной переменной
    echo $newpath
}

# Использование функции
# echo '++++'
# time shorten_path
# echo '++++'

echo '[x]----------------------------'
time _get_git_avil_prompt
echo
echo '-------------------------------'

# All colors

# for x in {0..8}; do
#     for i in {30..37}; do
#         for a in {40..47}; do
#             echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
#         done
#         echo
#     done
# done
# echo ""

# for fgbg in 38 48 ; do # Foreground / Background
#     for color in {0..255} ; do # Colors
#         # Display the color
#         echo -en "\e[${fgbg};5;${color}m \\\e[${fgbg};5;${color}m \t\e[0m"
#         # Display 10 colors per line
#         if [ $((($color + 1) % 10)) == 0 ] ; then
#             echo # New line
#         fi
#     done
#     echo # New line
# done
