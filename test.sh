#!/bin/bash

# GIT PROMP
_get_git_avil_prompt() {
    _my_trim() {
        echo $1 | sed -e 's/^[[:space:]]*//g'
    }

    local GitPrompt=""
    if git rev-parse --git-dir >/dev/null 2>&1; then
        # has branch
        if [ $(git branch | wc -l) -ne '0' ]; then
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
            local gpCountStaged=$(git diff --name-status --staged | wc -l)

            # unstaged changes
            local gpUnstaged=$(git diff --name-status | cut -c 1)
            local gpCountModified=$(echo "$gpUnstaged" | grep -c M)
            local gpCountDeleted=$(echo "$gpUnstaged" | grep -c D)
            local gpCountUntracked=$(git ls-files -o --exclude-standard | wc -l)
            local gpCountUnmerged=$(git ls-files --unmerged | cut -f2 | sort -u | wc -l)
            # stash lines
            local countStashes=$(git stash list | wc -l)

            # commits differences
            # local gpBranch=$(_my_trim "$(git branch | grep --color=never '*' | tail -c +3)")
            local gpBranch_abbr=$(git rev-parse --abbrev-ref HEAD)
            local gpBranch_hash=$(git rev-parse --short=5 HEAD)
            local gpBranch="${gpBranch_abbr} (${gpBranch_hash})"

            ## Formatting
            # region [ gpFirstHalf ]
            if [[ -d "$(git rev-parse --git-path rebase-merge)" ]]; then
                if [[ -f "$(git rev-parse --git-path REBASE_HEAD)" ]]; then
                    gpFirstHalf="${gpFirstHalf}${gpIsRebaseMessage}"
                fi

                if [[ -f "$(git rev-parse --git-path MERGE_HEAD)" ]]; then
                    gpFirstHalf="${gpFirstHalf}${gpIsMergeMessage}"
                fi
            fi

            if [ $gpBehind -ne "0" ]; then
                gpFirstHalf="${gpFirstHalf}${gpFormatBehind}${gpBehind}"
            fi
            # endregion

            if [ -z "${gpFirstHalf}" ]; then
                gpFirstHalf="${gpFormatEqual}"
            fi

            gpFirstHalf="${gpPrefix}${gpFormatBranch}${gpBranch}${gpFirstHalf}"

            # region [ gpSecondHalf ]
            if [ "$gpCountStaged" -ne "0" ]; then
                gpSecondHalf="${gpFormatStaged}${gpCountStaged}"
            fi

            if [ "$gpCountModified" -ne "0" ]; then
                gpSecondHalf="${gpSecondHalf}${gpFormatEdit}${gpCountModified}"
            fi

            if [ "$gpCountDeleted" -ne "0" ]; then
                gpSecondHalf="${gpSecondHalf}${gpFormatDel}${gpCountDeleted}"
            fi

            if [ "$gpCountUntracked" -ne "0" ]; then
                gpSecondHalf="${gpSecondHalf}${gpFormatUntracked}${gpCountUntracked}"
            fi

            if [ "$countStashes" -ne "0" ]; then
                gpSecondHalf="${gpSecondHalf}${gpFormatStashes}${countStashes}"
            fi

            if [ "$gpCountUnmerged" -ne "0" ]; then
                gpSecondHalf="${gpSecondHalf}${gpFormatUnmerged}${gpCountUnmerged}"
            fi
            # endregion

            if [ -z "${gpSecondHalf}" ]; then
                GitPrompt="${gpFirstHalf}${gpSuffix}"
            else
                gpSecondHalf=$(_my_trim $gpSecondHalf)
                GitPrompt="${gpFirstHalf}${gpSeparator}${gpSecondHalf}${gpSuffix}"
            fi

        else
            echo -ne "$\033[0;35m [no branch] \033[0m"
        fi

        # detecting virtualenv
        if [[ -n "${VIRTUAL_ENV}" ]]; then
            # we take care of printing virtualenv
            GitPrompt="\033[38;5;27m($(basename "${VIRTUAL_ENV}"))${ResetColor} ${GitPrompt}"
        fi

        echo -ne "$GitPrompt"
    fi
}

# TEST
cd ~/git/TEMP/subsurface-for-dirk
time _get_git_avil_prompt

echo '---'
_get_git_avil_prompt
echo -e '\n---'
