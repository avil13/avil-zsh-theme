# AVIL ZSH Theme

# region [GIT PROMP]
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
            local GP_IsRebaseMessage="\033[0;41m REBASE \033[0m"
            local GP_IsMergeMessage="\033[0;41m MERGE \033[0m"
            local GP_IsCherryMessage="\033[0;41m CHERRY \033[0m"
            #endregion

            local GP_BRANCH="$(git rev-parse --abbrev-ref HEAD) ($(git rev-parse --short=5 HEAD))"

            # region [ REBASE]
            local GP_MERGE_OR_REBASE=""

            if [[ -d "$(git rev-parse --git-path rebase-merge)" ]] && [[ -f "$(git rev-parse --git-path REBASE_HEAD)" ]]; then
                GP_MERGE_OR_REBASE="${GP_IsRebaseMessage}"
            elif [[ -f "$(git rev-parse --git-path MERGE_HEAD)" ]]; then
                GP_MERGE_OR_REBASE="${GP_IsMergeMessage}"
            elif [[ -f "$(git rev-parse --git-path CHERRY_PICK_HEAD)" ]]; then
                GP_MERGE_OR_REBASE="${GP_IsCherryMessage}"
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

_folder_path_icon() {
    if [ -x "$(command -v md5)" ]; then
        local P=$(md5 -s "$1")

        local HASH_NUM="$(echo "$P" | sed -E 's/[^0-9]//g')"
        local ICON_INDEX=${HASH_NUM:(${#HASH_NUM} - 2)}
        local ICONS=(
            "📁" "🏆" "💤" "🌀" "🃏" "🤘" "👌" "🎮" "😎" "🤑"
            "💻" "💾" "💎" "🦅" "🏴" "👺" "🦎" "😈" "👾" "📄"
            "🧅" "🐁" "🤖" "🔆" "💠" "💯" "☯" "🆒" "🧛" "😜"
            "🐻" "🙈" "🙉" "🙊" "🐕" "🐺" "🦁" "🐯" "🐴" "🤡"
            "🐇" "🐥" "🦆" "🦢" "🦉" "🦖" "🐉" "🐲" "🥴" "🧉"
            "🌍" "🌑" "🌓" "🌖" "🌙" "🚀" "🎪" "💀" "☠️" "🤩"
            "🔥" "⛄" "🌊" "💧" "🍔" "🍏" "🍎" "🍒" "🦹" "🧊"
            "🍐" "🍄" "🍕" "🥚" "🍿" "🥡" "☕" "💴" "💸" "🍓"
            "🍶" "🍾" "🍷" "🍸" "🍹" "🍺" "🍻" "🥂" "🥃" "🥤"
            "🥦" "🍗" "🍇" "🥥" "🤠" "🌊" "🤤" "😼" "🖖" "🦄"
        )

        echo ${ICONS[$ICON_INDEX]}
    fi
}

# settings
typeset +H _current_dir="%{$FG[014]%}%0~%{$reset_color%}"
typeset +H _return_status=" %(?.✔.%{$fg[red]%}%?%f)"
typeset +H _hist_no="%{$fg[grey]%}%h%{$reset_color%}"
typeset +H _PS_ICON='▶'

if [[ $UID == 0 || $EUID == 0 ]]; then
    typeset +H _PS_ICON="%{$fg_bold[red]%}#%{$reset_color%}"
fi

RPROMPT='${_return_status}'
PROMPT='$(_get_git_avil_prompt)$(_folder_path_icon $(pwd)) ${_current_dir}
%{%(!.%F{red}.%F{white})%}${_PS_ICON}%{$reset_color%} '

PROMPT2='%{%(!.%F{red}.%F{white})%}◀%{$reset_color%} '

MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
