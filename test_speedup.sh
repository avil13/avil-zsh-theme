#!/bin/bash

# source ./avil.zsh-theme

# region [GIT PROMP]
_get_git_avil_prompt() {
    local off='\033[0m' # Text Reset
    # Regular Colors
    local redBG='\033[0;41m'
    local red='\033[0;31m'
    local green='\033[0;32m'
    local yellow='\033[0;33m'
    local orange='\033[38;5;202m'
    local blue='\033[0;34m'
    local purple='\033[0;35m'
    local cyan='\033[0;36m'
    local gray='\033[37m'

    local REPO_PATH BRANCH HASH MODE STATE_TMP PROMPT STATUS

    REPO_PATH=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -e "$REPO_PATH" ]]; then
        PROMPT=$off

        if [[ -e "${REPO_PATH}/logs/HEAD" ]]; then
            # git found
            STATUS=$(git status --porcelain -uall | cut -c 1,2)
            BRANCH="$(git rev-parse --abbrev-ref HEAD)"
            HASH="$(git rev-parse --short=5 HEAD)"

            if [[ -e "${REPO_PATH}/BISECT_LOG" ]]; then
                MODE="$redBG BISECT "
            elif [[ -e "${REPO_PATH}/MERGE_HEAD" ]]; then
                MODE="$redBG ↝ MERGE "
            elif [[ -e "${REPO_PATH}/CHERRY_PICK_HEAD" ]]; then
                MODE="$redBG 🜼 CHERRY "
            elif [[ -e "${REPO_PATH}/rebase" || -e "${REPO_PATH}/rebase-apply" || -e "${REPO_PATH}/rebase-merge" ]]; then
                MODE="$redBG ↸ REBASE "
            fi

            # conflict
            STATE_TMP=$(echo "$STATUS" | grep 'UU' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$red ⚔$STATE_TMP"
            fi

            if [[ -e "${REPO_PATH}/ORIG_HEAD" ]]; then
                # need push
                STATE_TMP=$(git rev-list @ --not --remotes | wc -l | sed -e 's/^[[:space:]]*//')
                if [ "$STATE_TMP" -ne '0' ]; then
                    PROMPT="$PROMPT$cyan ￪$STATE_TMP"
                fi

                # need pull
                if [ -e "$REPO_PATH/refs/remotes/origin/$BRANCH" ]; then
                    STATE_TMP=$(git rev-list --count @..origin/$BRANCH)
                    if [ "$STATE_TMP" -ne '0' ]; then
                        PROMPT="$PROMPT$cyan ￬$STATE_TMP"
                    fi
                fi
            fi

            # staged
            STATE_TMP=$(echo "$STATUS" | grep '^M' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$green ●$STATE_TMP"
            fi

            # new staged
            STATE_TMP=$(echo "$STATUS" | grep 'A' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$green 𛲜$STATE_TMP"
            fi

            # deleted staged
            STATE_TMP=$(echo "$STATUS" | grep '^D' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$green ⊝$STATE_TMP"
            fi

            # deleted
            STATE_TMP=$(echo "$STATUS" | grep '.D' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$red ⊖$STATE_TMP"
            fi

            # changed not staged
            STATE_TMP=$(echo "$STATUS" | grep '.M' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$blue ✚$STATE_TMP"
            fi

            # untracked
            STATE_TMP=$(echo "$STATUS" | grep '??' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$yellow ?$STATE_TMP"
            fi

            # untracked
            STATE_TMP=$(echo "$STATUS" | grep 'R' | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$yellow ↹$STATE_TMP"
            fi

            # stash
            STATE_TMP=$(git stash list | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$STATE_TMP" -ne '0' ]; then
                PROMPT="$PROMPT$gray ≡$STATE_TMP"
            fi
        else
            # git only initialized
            BRANCH='No commits'
            HASH='-'
        fi

        PROMPT=$(echo $PROMPT | sed -e 's/^[[:space:]]*//')

        echo -e "${orange}[${purple}${BRANCH} (${HASH})${MODE}${PROMPT}${orange}]${off}"
    fi
}
# endregion

# time _get_git_avil_prompt
# echo '[x]----------------------------'
# _get_git_avil_prompt
# echo '-------------------------------'

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
echo '++++'
time shorten_path
echo '++++'

time _get_git_avil_prompt
echo '[x]----------------------------'
_get_git_avil_prompt
echo
_new_prompt
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
