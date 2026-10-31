#!/bin/zsh
# Run from the repository to measure: zsh -f /path/to/tests/benchmark.zsh
# Measures synchronous rendering only; does not read/write the prompt cache.
source "${0:A:h:h}/avil.zsh-theme"
zmodload zsh/datetime
repo=$(git rev-parse --git-dir 2>/dev/null) || { print -u2 'Run inside a Git repository'; exit 1; }
float start total=0
for i in {1..10}; do
    start=$EPOCHREALTIME
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null)
    head=$(_avil_git_head_segment "$branch")
    tail=$(_avil_build_git_status_tail "$repo" "" "$branch")
    _avil_git_prompt_box_line "$head" "$tail" >/dev/null
    (( total += (EPOCHREALTIME - start) * 1000 ))
done
printf 'Synchronous Git segment: %.2f ms mean (10 runs)\n' $(( total / 10 ))
