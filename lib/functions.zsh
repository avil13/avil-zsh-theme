
# region [GIT PROMP]
_get_git_avil_prompt() {
    local off='\033[0m' # Text Reset
    # Regular Colors
    local cTitle='\033[0;31;43m'
    local redBG='\033[0;35;41m'

    local cIndex='\033[1;32;47m'
    local cDeleted='\033[1;31;47m'
    local cNew='\033[1;33;47m'
    local cChanged='\033[1;34;47m'
    local cPush='\033[1;34;47m'
    local cStash='\033[1;30;47m'
    local cStart='\033[0;37;43m'
    local cEnd="\033[0;37m%{$BG[072]%}"

    local REPO_PATH=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -e "$REPO_PATH" ]]; then
        local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        local HASH=$(git rev-parse --short=5 HEAD 2>/dev/null)
        local STATUS=$(git status --porcelain -uall 2>/dev/null)
        local PROMPT="${cStart}\033[0;33;47m "
        local MODE=""

        [[ -e "${REPO_PATH}/BISECT_LOG" ]] && MODE="${redBG} BISECT "
        [[ -e "${REPO_PATH}/MERGE_HEAD" ]] && MODE="${redBG} ↝ MERGE "
        [[ -e "${REPO_PATH}/CHERRY_PICK_HEAD" ]] && MODE="${redBG} 🜼 CHERRY "
        [[ -e "${REPO_PATH}/rebase" || -e "${REPO_PATH}/rebase-apply" || -e "${REPO_PATH}/rebase-merge" ]] && MODE="${redBG} ↸ REBASE"

        local CONFLICT=$(echo "$STATUS" | grep -c 'UU')
        local NEED_PUSH=$(git rev-list @ --not --remotes 2>/dev/null | wc -l | tr -d ' ')
        local NEED_PULL=$(git rev-list --count @..origin/$BRANCH 2>/dev/null)
        local STAGED=$(echo "$STATUS" | grep -c '^M')
        local NEW_STAGED=$(echo "$STATUS" | grep -c 'A')
        local STAGED_DELETED=$(echo "$STATUS" | grep -c '^D')
        local DELETED=$(echo "$STATUS" | grep -c '.D')
        local MODIFIED=$(echo "$STATUS" | grep -c '.M')
        local UNTRACKED=$(echo "$STATUS" | grep -c '??')
        local RENAMED=$(echo "$STATUS" | grep -c 'R')
        local STASHED=$(git stash list | wc -l | tr -d ' ')

        [[ $CONFLICT -ne 0 ]] && PROMPT+="${cDeleted}⚔${CONFLICT} "
        [[ $NEED_PUSH -ne 0 ]] && PROMPT+="${cPush}￪${NEED_PUSH} "
        [[ $NEED_PULL -ne 0 ]] && PROMPT+="${cPush}￬${NEED_PULL} "
        [[ $STAGED -ne 0 ]] && PROMPT+="${cIndex}●${STAGED} "
        [[ $NEW_STAGED -ne 0 ]] && PROMPT+="${cIndex}𛲜${NEW_STAGED} "
        [[ $STAGED_DELETED -ne 0 ]] && PROMPT+="${cIndex}⊝${STAGED_DELETED} "
        [[ $MODIFIED -ne 0 ]] && PROMPT+="${cChanged}✚${MODIFIED} "
        [[ $UNTRACKED -ne 0 ]] && PROMPT+="${cNew}?${UNTRACKED} "
        [[ $RENAMED -ne 0 ]] && PROMPT+="${cNew}↹${RENAMED} "
        [[ $DELETED -ne 0 ]] && PROMPT+="${cDeleted}⊖${DELETED} "
        [[ $STASHED -ne 0 ]] && PROMPT+="${cStash}≡${STASHED} "

        PROMPT="${cTitle} ${BRANCH} (${HASH})${MODE}${PROMPT}${cEnd}${off}"
        echo -e "${PROMPT}"
    fi
}
# endregion
