
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

    local REPO_PATH=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -e "$REPO_PATH" ]]; then
        local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        local HASH=$(git rev-parse --short=5 HEAD 2>/dev/null)
        local STATUS=$(git status --porcelain -uall 2>/dev/null)
        local PROMPT=""
        local MODE=""

        [[ -e "${REPO_PATH}/BISECT_LOG" ]] && MODE="${redBG}BISECT"
        [[ -e "${REPO_PATH}/MERGE_HEAD" ]] && MODE="${redBG}MERGE"
        [[ -e "${REPO_PATH}/CHERRY_PICK_HEAD" ]] && MODE="${redBG}CHERRY"
        [[ -e "${REPO_PATH}/rebase" || -e "${REPO_PATH}/rebase-apply" || -e "${REPO_PATH}/rebase-merge" ]] && MODE="${redBG}REBASE"

        local CONFLICT=$(echo "$STATUS" | grep -c 'UU')
        local NEED_PUSH=$(git rev-list @ --not --remotes 2>/dev/null | wc -l | tr -d ' ')
        local NEED_PULL=$(git rev-list --count @..origin/$BRANCH 2>/dev/null)
        local STAGED=$(echo "$STATUS" | grep -c '^M')
        local NEW_STAGED=$(echo "$STATUS" | grep -c '^A')
        local DELETED_STAGED=$(echo "$STATUS" | grep -c '^D')
        local MODIFIED=$(echo "$STATUS" | grep -c ' M')
        local UNTRACKED=$(echo "$STATUS" | grep -c '??')
        local RENAMED=$(echo "$STATUS" | grep -c '^R')
        local STASHED=$(git stash list | wc -l | tr -d ' ')

        [[ $CONFLICT -ne 0 ]] && PROMPT+="${red}⚔${CONFLICT} "
        [[ $NEED_PUSH -ne 0 ]] && PROMPT+="${cyan}￪${NEED_PUSH} "
        [[ $NEED_PULL -ne 0 ]] && PROMPT+="${cyan}￬${NEED_PULL} "
        [[ $STAGED -ne 0 ]] && PROMPT+="${green}●${STAGED} "
        [[ $NEW_STAGED -ne 0 ]] && PROMPT+="${green}𛲜${NEW_STAGED} "
        [[ $DELETED_STAGED -ne 0 ]] && PROMPT+="${green}⊝${DELETED_STAGED} "
        [[ $MODIFIED -ne 0 ]] && PROMPT+="${blue}✚${MODIFIED} "
        [[ $UNTRACKED -ne 0 ]] && PROMPT+="${yellow}?${UNTRACKED} "
        [[ $RENAMED -ne 0 ]] && PROMPT+="${yellow}↹${RENAMED} "
        [[ $STASHED -ne 0 ]] && PROMPT+="${gray}≡${STASHED} "

        PROMPT="${orange}⟬${purple}${BRANCH} (${HASH})${MODE} ${PROMPT}${orange}⟭${off}"
        echo -e "${PROMPT}"
    fi
}
# endregion
