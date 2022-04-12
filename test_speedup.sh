#!/bin/bash

# source ./avil.zsh-theme

# GIT PROMP
# region [ NEW ]
_get_git_avil_prompt() {
    # _trim() {
    #     echo $1 | sed -e 's/^[[:space:]]*//'
    # }

    if git rev-parse --git-dir >/dev/null 2>&1; then
        # we are in a git repo
        if [ $(git branch | wc -l | sed -e 's/^[[:space:]]*//') -ne '0' ]; then
            # has branch
            #region [colors]
            local GP_ColReset='\033[0m'
            local GP_ColDelimiters='\033[38;5;202m'
            # format
            local GP_ICO_Prefix="${GP_ColDelimiters}["
            local GP_FirstHalf=""
            local GP_SecondHalf=""
            local GP_Separator="${GP_ColDelimiters}|"
            local GP_ICO_Suffix="${GP_ColDelimiters}]$GP_ColReset "
            # prefixes
            local GP_COLOR_Branch="\033[38;5;5m"
            local GP_ICO_Ahead="\033[38;5;39m ↑"
            # local GP_Behind="\033[38;5;196m ↓" # deprecated
            local GP_Equal="\033[38;5;46m ✔"
            local GP_ICO_Staged="\033[38;5;48m ●"
            local GP_ICO_Edit="\033[38;5;27m ✚"
            local GP_ICO_Del="\033[38;5;160m ✖"
            local GP_ICO_Untracked="\033[38;5;214m ?"
            local GP_ICO_Stashes="\033[37m ≡"
            local GP_ICO_Unmerged="\033[38;5;160m ⊗"
            local GP_IsRebaseMessage=" \033[0;41mREBASE\033[0m"
            local GP_IsMergeMessage=" \033[0;41mMERGE\033[0m"
            #endregion

            local GP_BRANCH="$(git rev-parse --abbrev-ref HEAD) ($(git rev-parse --short=5 HEAD))"

            # region [ REBASE]
            local GP_MERGE_OR_REBASE=""

            if [[ -d "$(git rev-parse --git-path rebase-merge)" ]]; then
                if [[ -f "$(git rev-parse --git-path REBASE_HEAD)" ]]; then
                    GP_MERGE_OR_REBASE="${GP_IsRebaseMessage}"
                elif [[ -f "$(git rev-parse --git-path MERGE_HEAD)" ]]; then
                    GP_MERGE_OR_REBASE="${GP_IsMergeMessage}"
                fi
            fi
            # endregion

            # region [ GP_SecondHalf ]

            # default if upstream doesn't exist
            local GP_Ahead=$(git rev-list HEAD --not --remotes | wc -l | sed -e 's/^[[:space:]]*//')
            if [ $GP_Ahead -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Ahead}${GP_Ahead}"
            fi

            local GP_CountStaged=$(git diff --name-status --staged | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$GP_CountStaged" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Staged}${GP_CountStaged}"
            fi

            # unstaged changes
            local GP_Unstaged=$(git diff --name-status | cut -c 1)
            local GP_CountModified=$(echo $GP_Unstaged | grep -c M)
            local GP_CountDeleted=$(echo $GP_Unstaged | grep -c D)

            if [ "$GP_CountModified" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Edit}${GP_CountModified}"
            fi

            if [ "$GP_CountDeleted" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Del}${GP_CountDeleted}"
            fi

            local GP_CountUntracked=$(git ls-files -o --exclude-standard | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$GP_CountUntracked" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Untracked}${GP_CountUntracked}"
            fi

            local GP_CountUnmerged=$(git ls-files --unmerged | cut -f2 | sort -u | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$GP_CountUnmerged" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Unmerged}${GP_CountUnmerged}"
            fi

            local GP_CountStashes=$(git stash list | wc -l | sed -e 's/^[[:space:]]*//')
            if [ "$GP_CountStashes" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Stashes}${GP_CountStashes}"
            fi
            # endregion

            if [ -n "${GP_SecondHalf}" ]; then
                GP_SecondHalf="${GP_Separator}${GP_SecondHalf}"
            fi

            echo -e "${GP_ICO_Prefix}${GP_COLOR_Branch}${GP_BRANCH}${GP_MERGE_OR_REBASE}${GP_SecondHalf}${GP_ICO_Suffix}"
        #
        else
            echo -ne "$\033[0;35m [no branch] \033[0m"
        fi
    fi
}
# endregion

# time _get_git_avil_prompt
# echo '[x]----------------------------'
# _get_git_avil_prompt
# echo '-------------------------------'

_folder_path_icon() {
    if [! command -v md5 &> /dev/null]; then
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

time _get_git_avil_prompt
echo '[x]----------------------------'
_get_git_avil_prompt
echo '-------------------------------'
