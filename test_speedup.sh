#!/bin/bash

# GIT PROMP
# region [ NEW ]
_NEW_get_git_avil_prompt() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        # we are in a git repo
        if [ $(git branch | wc -l) -ne '0' ]; then
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
            local GP_Ahead=$(git rev-list HEAD --not --remotes | wc -l)
            if [ $GP_Ahead -ne "0" ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Ahead}${GP_Ahead}"
            fi

            local GP_CountStaged=$(git diff --name-status --staged | wc -l)
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

            local GP_CountUntracked=$(git ls-files -o --exclude-standard | wc -l)
            if [ "$GP_CountUntracked" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Untracked}${GP_CountUntracked}"
            fi

            local GP_CountUnmerged=$(git ls-files --unmerged | cut -f2 | sort -u | wc -l)
            if [ "$GP_CountUnmerged" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Unmerged}${GP_CountUnmerged}"
            fi

            local GP_CountStashes=$(git stash list | wc -l)
            if [ "$GP_CountStashes" -ne '0' ]; then
                GP_SecondHalf="${GP_SecondHalf}${GP_ICO_Stashes}${GP_CountStashes}"
            fi
            # endregion

            if [ -n "${GP_SecondHalf}" ]; then
                # remove spaces
                # GP_SecondHalf=$(echo $GP_SecondHalf | sed 's/ //g')
                GP_SecondHalf=$(echo $GP_SecondHalf | sed -r 's/\d//g')
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

# region [ OLD]

_OLD_get_git_avil_prompt() {
  _my_trim() {
    echo $1 | sed -e 's/^[[:space:]]*//'
  }
  local GitPrompt=""
  if git rev-parse --git-dir > /dev/null 2>&1
  then
    # has branch
    if [ $(git branch | wc -l) -ne '0' ]
    then
      # we are in a git repo

      # colors
      local gpColReset='\033[0m'
      local gpColDelimiters='\033[38;5;202m'

      # format
      local gpPrefix="${gpColDelimiters}["
      local gpFirstHalf=""
      local gpSecondHalf=""
      local gpSeparator="${gpColDelimiters}|"
      local gpSuffix="${gpColDelimiters}]$gpColReset "
      # prefixes
      local gpFormatBranch="\033[38;5;5m"
      local gpFormatAhead="\033[38;5;39m ↑"
      local gpFormatBehind="\033[38;5;196m ↓"
      local gpFormatEqual="\033[38;5;46m ✔"
      local gpFormatStaged="\033[38;5;48m ●"
      local gpFormatEdit="\033[38;5;27m ✚"
      local gpFormatDel="\033[38;5;160m ✖"
      local gpFormatUntracked="\033[38;5;214m ?"
      local gpFormatStashes="\033[37m ≡"
      local gpFormatUnmerged="\033[38;5;160m ⊗"
      local gpIsRebaseMessage=" \033[0;41mREBASE\033[0m"
      local gpIsMergeMessage=" \033[0;41mMERGE\033[0m"

      # staged changes
      local gpCountStaged=$(_my_trim "$(git diff --name-status --staged | wc -l)")

      # unstaged changes
      local gpUnstaged=$(git diff --name-status | cut -c 1)
      local gpCountModified=$(_my_trim $(echo "$gpUnstaged" | grep -c M))
      local gpCountDeleted=$(_my_trim $(echo "$gpUnstaged" | grep -c D))
      local gpCountUntracked=$(_my_trim "$(git ls-files -o --exclude-standard | wc -l)")
      local gpCountUnmerged=$(_my_trim "$(git ls-files --unmerged | cut -f2 | sort -u | wc -l)")
      # stash lines
      local countStashes=$(_my_trim "$(git stash list | wc -l)")

      # commits differences
      # local gpBranch=$(_my_trim "$(git branch | grep --color=never '*' | tail -c +3)")
      local gpBranch_abbr=$(git rev-parse --abbrev-ref HEAD)
      local gpBranch_hash=$(git rev-parse --short=5 HEAD)
      local gpBranch="${gpBranch_abbr} (${gpBranch_hash})"

      # default if upstream doesn't exist
      local gpAhead=$(_my_trim "$(git rev-list HEAD --not --remotes | wc -l)")
      # local gpBehind="0"
      # git show-ref --verify --quiet refs/remotes/origin/${gpBranch}
      # local gpUpExists=$?
      # # if the remote branch exists, compare to it

      # [ $gpUpExists -eq 0 ] && gpAhead=$(_my_trim "$(git rev-list HEAD --not origin/${gpBranch} | wc -l)")
      # [ $gpUpExists -eq 0 ] && gpBehind=$(_my_trim "$(git rev-list origin/${gpBranch} --not ${gpBranch} | wc -l)")

      # Formatting
      if [[ -d "$(git rev-parse --git-path rebase-merge)" ]]
      then
        if [[ -f "$(git rev-parse --git-path REBASE_HEAD)" ]]
        then
          gpFirstHalf="${gpFirstHalf}${gpIsRebaseMessage}"
        fi

        if [[ -f "$(git rev-parse --git-path MERGE_HEAD)" ]]
        then
          gpFirstHalf="${gpFirstHalf}${gpIsMergeMessage}"
        fi
      fi

      if [ $gpAhead -ne "0" ]
      then
        gpFirstHalf="${gpFirstHalf}${gpFormatAhead}${gpAhead}"
      fi

      # if [ $gpBehind -ne "0" ]
      # then
      #   gpFirstHalf="${gpFirstHalf}${gpFormatBehind}${gpBehind}"
      # fi

    if [ -z "${gpFirstHalf}" ]
      then
        gpFirstHalf="${gpFormatEqual}"
      fi
      gpFirstHalf="${gpPrefix}${gpFormatBranch}${gpBranch}${gpFirstHalf}"

      if [ "$gpCountStaged" -ne "0" ]
      then
        gpSecondHalf="${gpFormatStaged}${gpCountStaged}"
      fi

      if [ "$gpCountModified" -ne "0" ]
      then
        gpSecondHalf="${gpSecondHalf}${gpFormatEdit}${gpCountModified}"
      fi

      if [ "$gpCountDeleted" -ne "0" ]
      then
        gpSecondHalf="${gpSecondHalf}${gpFormatDel}${gpCountDeleted}"
      fi

      if [ "$gpCountUntracked" -ne "0" ]
      then
        gpSecondHalf="${gpSecondHalf}${gpFormatUntracked}${gpCountUntracked}"
      fi

      if [ "$countStashes" -ne "0" ]
      then
        gpSecondHalf="${gpSecondHalf}${gpFormatStashes}${countStashes}"
      fi

      if [ "$gpCountUnmerged" -ne "0" ]
      then
        gpSecondHalf="${gpSecondHalf}${gpFormatUnmerged}${gpCountUnmerged}"
      fi

      if [ -z "${gpSecondHalf}" ]
      then
        GitPrompt="${gpFirstHalf}${gpSuffix}"
      else
        GitPrompt="${gpFirstHalf}${gpSeparator}${gpSecondHalf}${gpSuffix}"
      fi

    else
      echo -ne "$\033[0;35m [no branch] \033[0m"
    fi

    # detecting virtualenv
    if [[ -n "${VIRTUAL_ENV}" ]]
    then
      # we take care of printing virtualenv
      GitPrompt="\033[38;5;27m($(basename "${VIRTUAL_ENV}"))${ResetColor} ${GitPrompt}"
    fi

    echo -ne "$GitPrompt"
  fi
}
# endregion

# time _NEW_get_git_avil_prompt
# time _OLD_get_git_avil_prompt
# echo '[new] ---------------------'
# _NEW_get_git_avil_prompt
# echo '[old] ---------------------'
# _OLD_get_git_avil_prompt
# echo '--------------------------------'





_folder_path_icon() {
    HASH_NUM="$(printf '%d' "'$(pwd)" | sed -E 's/[^0-9]//g')"
    ICON_INDEX=${HASH_NUM:0:2}
    ICONS=(
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

time _folder_path_icon
echo '---------------------'
_folder_path_icon
echo '---------------------'
HASH_NUM="$(md5 -s $(pwd) | sed  -E 's/[^0-9]//g' )"
ICON_INDEX=${HASH_NUM:0:2}

echo "${HASH_NUM} ${ICON_INDEX}"
echo '---------------------'

