#!/bin/bash

_folder_path_icon() {
    local P="$1"

    if [ -x "$(command -v md5)" ]; then
        P=$(md5 -s "$P")
    fi

    if [ -x "$(command -v md5sum)" ]; then
        P=$(md5sum -s "$P")
    fi

    local HASH_NUM="$(echo "$P" | sed -E 's/[^0-9]//g')"
    local ICON_INDEX=${HASH_NUM:(${#HASH_NUM} - 2)}
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

# _folder_path_icon $(pwd)
# _folder_path_icon ''
# _folder_path_icon '/'

# === pwd path ===

_color_path() {
    local P=$(pwd | sed -u -a s#$HOME#~#)
    local C0="\033[m"
    local C1="\033[38;5;67m"
    local C2="\033[38;5;37m"
    local B="\033[1m"
    echo -e "${C1}${P%/*}/${C2}${B}${P##*/}${C0}"
}

_color_path

# for i in {0..255}; do
#     echo -en "\033[38;5;${i}m Hello(${i})\t \033[m"
# done
