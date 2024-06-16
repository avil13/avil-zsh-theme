# AVIL ZSH Theme

# region [GIT PROMP]
_get_git_avil_prompt() {
    local off='\033[0m' # Text Reset
    # Regular Colors
    local cOrange='\033[38;5;202m'
    local cTitle='\033[38;5;212m' # local purple='\033[0;35m'
    local redBG='\033[0;35;41m'

    local cIndex='\033[0;32m' # green
    local cDeleted='\033[0;31m' # red
    local cNew='\033[0;33m' # yellow
    local cChanged='\033[0;34m' # blue
    local cPush='\033[0;36m' # cyan
    local cStash='\033[0;37m' # gray

    local REPO_PATH=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -e "$REPO_PATH" ]]; then
        local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        local HASH=$(git rev-parse --short=5 HEAD 2>/dev/null)
        local STATUS=$(git status --porcelain -uall | cut -c 1,2)
        local PROMPT=""
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

        [[ $CONFLICT -ne 0 ]] && PROMPT+=" ${cDeleted}⚔${CONFLICT}"
        [[ $NEED_PUSH -ne 0 ]] && PROMPT+=" ${cPush}￪${NEED_PUSH}"
        [[ $NEED_PULL -ne 0 ]] && PROMPT+=" ${cPush}￬${NEED_PULL}"
        [[ $STAGED -ne 0 ]] && PROMPT+=" ${cIndex}●${STAGED}"
        [[ $NEW_STAGED -ne 0 ]] && PROMPT+=" ${cIndex}𛲜${NEW_STAGED}"
        [[ $STAGED_DELETED -ne 0 ]] && PROMPT+=" ${cIndex}⊝${STAGED_DELETED}"
        [[ $MODIFIED -ne 0 ]] && PROMPT+=" ${cChanged}✚${MODIFIED}"
        [[ $UNTRACKED -ne 0 ]] && PROMPT+=" ${cNew}?${UNTRACKED}"
        [[ $RENAMED -ne 0 ]] && PROMPT+=" ${cNew}↹${RENAMED}"
        [[ $DELETED -ne 0 ]] && PROMPT+=" ${cDeleted}⊝${DELETED}"
        [[ $STASHED -ne 0 ]] && PROMPT+=" ${cStash}≡${STASHED}"

        PROMPT="${cOrange}⟬${off}${cTitle}${BRANCH} (${HASH})${MODE}${PROMPT}${cOrange}⟭${off}"
        echo -e "${PROMPT}"
    fi
}
# endregion

# settings
if [[ $UID == 0 || $EUID == 0 ]]; then
    typeset +H _PS_ICON="%{$fg_bold[red]%}#%f"
else
    typeset +H _PS_ICON='%F{blue}❯%f'
fi

typeset +H _return_status=" %(?.✔.%{$fg[red]%}%?%f)"

setopt PROMPT_SUBST

PROMPT='
$(_get_git_avil_prompt)%F{cyan}%~%f
%{%(!.%F{red}.%F{blue})%}${_PS_ICON}%f '
PROMPT2='%{%(!.%F{red}.%F{white})%}◀%f'
RPROMPT='${_return_status}'
MODE_INDICATOR="%{$fg_bold[yellow]%}❮%f%{$fg[yellow]%}❮❮%f"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
