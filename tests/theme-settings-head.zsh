#!/bin/zsh
# Run with: zsh -f tests/theme-settings-head.zsh
setopt ERR_EXIT
THEME=${0:A:h:h}/avil.zsh-theme
fail() { print -u2 -- "$*"; exit 1; }

(
    unset LSCOLORS LS_COLORS ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE
    source "$THEME"
    [[ $LSCOLORS == exfxcxdxbxegedabagacad && -n $LS_COLORS && $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE == fg=8 ]] || fail 'Missing defaults'
)
for value in custom ''; do
    (
        LSCOLORS=$value LS_COLORS=$value ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=$value
        source "$THEME"
        [[ $LSCOLORS == "$value" && $LS_COLORS == "$value" && $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE == "$value" ]] || fail 'User settings overwritten'
    )
done

source "$THEME"
zmodload zsh/datetime
sandbox=$(mktemp -d)
trap 'rm -rf -- "$sandbox"' EXIT
mkdir "$sandbox/repo"
cd "$sandbox/repo"
git init -q -b main
git config user.name Test
git config user.email test@example.invalid

result=$(_get_git_avil_prompt 2>"$sandbox/errors")
[[ $result == *main* && $result != *'()'* && ! -s "$sandbox/errors" ]] || fail 'Incorrect unborn HEAD'

print initial > tracked
git add tracked
git -c commit.gpgsign=false commit -qm initial
hash=$(git rev-parse --short=5 HEAD)
result=$(_get_git_avil_prompt 2>"$sandbox/errors")
[[ $result == *main* && $result == *"($hash)"* && ! -s "$sandbox/errors" ]] || fail 'Incorrect normal branch'

git checkout -q --detach
result=$(_get_git_avil_prompt 2>"$sandbox/errors")
[[ $result == *"$hash"* && $result != *HEAD* && $result != *"($hash)"* && ! -s "$sandbox/errors" ]] || fail 'Incorrect detached HEAD'
print 'Theme settings and HEAD states: OK'
