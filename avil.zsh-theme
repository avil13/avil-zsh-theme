# AVIL ZSH Theme

# region [GIT PROMPT BUILDER]
# Branch name only (fast; always fresh). Hash is in the cached tail.
_avil_git_head_segment() {
    local cTitle='\033[38;5;212m'
    local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    echo -e "${cTitle}${BRANCH}"
}

# (HASH) + MODE + status icons (slow; cached as a whole)
_avil_build_git_status_tail() {
    local REPO_PATH="$1"
    local IS_CACHE_HIT="$2"

    local cTitle='\033[38;5;212m'
    local redBG='\033[0;37;41m'
    local cIndex='\033[0;32m'
    local cDeleted='\033[0;31m'
    local cNew='\033[0;33m'
    local cChanged='\033[0;34m'
    local cPush='\033[0;36m'
    local cStash='\033[0;37m'

    local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    local HASH=$(git rev-parse --short=5 HEAD 2>/dev/null)
    local STATUS=$(git status --porcelain -uall | cut -c 1,2)
    local PROMPT=""
    local MODE=""

    [[ -e "${REPO_PATH}/BISECT_LOG" ]] && MODE="${redBG} BISECT "
    [[ -e "${REPO_PATH}/MERGE_HEAD" ]] && MODE="${redBG} ↝ MERGE "
    [[ -e "${REPO_PATH}/CHERRY_PICK_HEAD" ]] && MODE="${redBG} 🜼 CHERRY "
    [[ -e "${REPO_PATH}/REVERT_HEAD" ]] && MODE="${redBG} ↷ REVERT "
    [[ -e "${REPO_PATH}/rebase" || -e "${REPO_PATH}/rebase-apply" || -e "${REPO_PATH}/rebase-merge" ]] && MODE="${redBG} ↸ REBASE"

    local CONFLICT=$(echo "$STATUS" | grep -c -E '^(DD|AU|UD|UA|DU|AA|UU)$')
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
    [[ $NEED_PUSH -ne 0 ]] && PROMPT+=" ${cPush}↑${NEED_PUSH}"
    [[ $NEED_PULL -ne 0 ]] && PROMPT+=" ${cPush}↓${NEED_PULL}"
    [[ $STAGED -ne 0 ]] && PROMPT+=" ${cIndex}●${STAGED}"
    [[ $NEW_STAGED -ne 0 ]] && PROMPT+=" ${cIndex}⊗${NEW_STAGED}"
    [[ $STAGED_DELETED -ne 0 ]] && PROMPT+=" ${cIndex}⊖${STAGED_DELETED}"
    [[ $MODIFIED -ne 0 ]] && PROMPT+=" ${cChanged}+${MODIFIED}"
    [[ $UNTRACKED -ne 0 ]] && PROMPT+=" ${cNew}?${UNTRACKED}"
    [[ $RENAMED -ne 0 ]] && PROMPT+=" ${cNew}↔${RENAMED}"
    [[ $DELETED -ne 0 ]] && PROMPT+=" ${cDeleted}⊝${DELETED}"
    [[ $STASHED -ne 0 ]] && PROMPT+=" ${cStash}≡${STASHED}"

    [[ $IS_CACHE_HIT == 1 ]] && PROMPT+="⏱️"

    echo -e "${cTitle} (${HASH})${MODE}${PROMPT}"
}

# Wrap head + tail in ⟬ ⟭ (shared by cache hit / miss)
_avil_git_prompt_box_line() {
    local off='\033[0m' cOrange='\033[38;5;202m'
    echo -e "${cOrange}⟬${off}${1}${2}${cOrange}⟭${off}"
}
# endregion

# region [GIT PROMPT]
_get_git_avil_prompt() {
    local REPO_PATH=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -e "$REPO_PATH" ]]; then
        # Cached tail starts with " (short-hash)"; branch name is always live in the head segment
        local CACHE_FILE="${REPO_PATH}/.avil-git-prompt-cache.tail-v2"

        # Cache hit: branch fresh; hash + status from cache; refresh tail in background
        if [[ -f "$CACHE_FILE" ]]; then
            local _avil_head _avil_tail
            _avil_head=$(_avil_git_head_segment)
            _avil_tail=$(command cat "$CACHE_FILE")
            _avil_git_prompt_box_line "$_avil_head" "$_avil_tail"
            {
                _avil_build_git_status_tail "$REPO_PATH" 1 > "${CACHE_FILE}.tmp" 2>/dev/null
                command mv -f "${CACHE_FILE}.tmp" "$CACHE_FILE" 2>/dev/null
            } >/dev/null 2>&1 &!
            return
        fi

        # Cache miss: compute synchronously, enable cache if slow (>400ms)
        local _avil_t=$(( EPOCHREALTIME * 1000 ))
        local _avil_head _avil_tail _avil_result
        _avil_head=$(_avil_git_head_segment)
        _avil_tail=$(_avil_build_git_status_tail "$REPO_PATH")
        _avil_result=$(_avil_git_prompt_box_line "$_avil_head" "$_avil_tail")
        printf '%s\n' "$_avil_result"
        if (( (EPOCHREALTIME * 1000) - _avil_t > 400 )); then
            printf '%s' "$_avil_tail" > "$CACHE_FILE"
        fi
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
