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
    expected=$'\033[38;5;212m (abcde) \033[0;31m⚔1 \033[0;36m↑3 \033[0;36m↓2'
    [[ $result == "$expected" ]] || { print -u2 -- "Incorrect $conflict counters: $result"; exit 1; }
done

local_status='MM both'
result=$(_avil_build_git_status_tail /nonexistent "" main)
expected=$'\033[38;5;212m (abcde) \033[0;36m↑3 \033[0;36m↓2 \033[0;32m●1 \033[0;34m+1'
[[ $result == "$expected" ]] || { print -u2 -- "Incorrect MM counters: $result"; exit 1; }

local_status=''
result=$(_avil_build_git_status_tail /nonexistent "" main)
expected=$'\033[38;5;212m (abcde) \033[0;36m↑3 \033[0;36m↓2'
[[ $result == "$expected" ]] || { print -u2 -- "Unexpected clean status: $result"; exit 1; }
print 'Git status counters: OK'
