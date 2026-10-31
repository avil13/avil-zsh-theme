#!/bin/zsh
# Run with: zsh -f tests/git-status-tail.zsh
source "${0:A:h:h}/avil.zsh-theme"

# Conflicts must not inflate index/worktree counters; MM counts in both.
local_status=$'M  staged\n M modified\nMM both\nA  added\n D deleted\nD  staged-deleted\nR  old -> new\n?? "untracked\\nfile"\nDD conflict\nAU conflict\nUD conflict\nUA conflict\nDU conflict\nAA conflict\nUU conflict'
stash_refs=$'stash@{0}\nstash@{1}'
git() {
    case "$*" in
        'rev-parse --short=5 HEAD') print -r -- abcde ;;
        'status --porcelain -uall') print -r -- "$local_status" ;;
        'rev-list --count @ --not --remotes') print 3 ;;
        'rev-list --count @..origin/main') print 2 ;;
        'stash list --format=%gd') print -r -- "$stash_refs" ;;
        *) print -u2 -- "Unexpected git command: $*"; return 1 ;;
    esac
}

result=$(_avil_build_git_status_tail /nonexistent "" main)
for token in '(abcde)' '⚔7' '↑3' '↓2' '●2' '⊗1' '⊖1' '+2' '?1' '↔1' '⊝1' '≡2'; do
    [[ $result == *"$token"* ]] || { print -u2 -- "Missing $token: $result"; exit 1; }
done

stash_refs=''
for conflict in DD AU UD UA DU AA UU; do
    local_status="$conflict conflict"
    result=$(_avil_build_git_status_tail /nonexistent "" main)
    expected='%F{212} (abcde) %F{red}⚔1 %F{cyan}↑3 %F{cyan}↓2'
    [[ $result == "$expected" ]] || { print -u2 -- "Incorrect $conflict counters: $result"; exit 1; }
done

local_status='MM both'
result=$(_avil_build_git_status_tail /nonexistent "" main)
expected='%F{212} (abcde) %F{cyan}↑3 %F{cyan}↓2 %F{green}●1 %F{blue}+1'
[[ $result == "$expected" ]] || { print -u2 -- "Incorrect MM counters: $result"; exit 1; }

local_status=''
result=$(_avil_build_git_status_tail /nonexistent "" main)
expected='%F{212} (abcde) %F{cyan}↑3 %F{cyan}↓2'
[[ $result == "$expected" ]] || { print -u2 -- "Unexpected clean status: $result"; exit 1; }
# Prompt escapes in branch names must remain literal and count as visible text.
COLUMNS=80
branch='feature/%F{red}/100%'
head=$(_avil_git_head_segment "$branch")
[[ $head == '%F{212}feature/%%F{red}/100%%' ]] || { print -u2 'Branch escaping failed'; exit 1; }
for width in ${#branch} $(( ${#branch} + 1 )); do
    rendered=$(print -rP -- "${head}%(${width}l.YES.NO)")
    if (( width == ${#branch} )); then
        [[ $rendered == *YES ]] || exit 1
    else
        [[ $rendered == *NO ]] || exit 1
    fi
done

sandbox=$(mktemp -d)
trap 'rm -rf -- "$sandbox"' EXIT
for marker in MERGE_HEAD rebase-merge; do
    touch "$sandbox/$marker"
    tail=$(_avil_build_git_status_tail "$sandbox" "" main)
    [[ $tail == *'%K{red}'*'%k%f'* ]] || { print -u2 'Operation background not reset'; exit 1; }
    box=$(_avil_git_prompt_box_line "$head" "$tail")
    [[ $box != *$'\033'* && $box == *'%F{202}⟭%f%k' ]] || { print -u2 'Incorrect box formatting'; exit 1; }
    rm "$sandbox/$marker"
done
print 'Git status counters and prompt formatting: OK'
