#!/bin/zsh
# Run with: zsh -f tests/git-status-tail.zsh
source "${0:A:h:h}/avil.zsh-theme"

# Keep the existing counter semantics, including overlapping conflict counters.
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
for token in '(abcde)' '⚔7' '↑3' '↓2' '●2' '⊗4' '⊖3' '+2' '?1' '↔1' '⊝3' '≡2'; do
    [[ $result == *"$token"* ]] || { print -u2 -- "Missing $token: $result"; exit 1; }
done

local_status=''
stash_refs=''
result=$(_avil_build_git_status_tail /nonexistent "" main)
expected=$'\033[38;5;212m (abcde) \033[0;36m↑3 \033[0;36m↓2'
[[ $result == "$expected" ]] || { print -u2 -- "Unexpected clean status: $result"; exit 1; }
print 'Git status counters: OK'
