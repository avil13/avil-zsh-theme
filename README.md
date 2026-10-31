# AVIL - zsh theme

---

The fastest and most informative zsh theme

---

This is a zsh-theme that is convenient for a developer.

To make it easier to remember which folder you are working in and not to make a mistake.

## Better git repository status.

![avil-zsh-theme-demo](./assets/konsole.avif)

# Installation

## If you're not a zsh user

- install zsh on you system
- make zsh as default sh
  - `chsh -s $(which zsh)`
- install **oh-my-zsh**
  - `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- You're a zsh user now.

## If you are a zsh user

Clone

```sh
git clone https://github.com/avil13/avil-zsh-theme.git ~/.oh-my-zsh/themes/avil
```

Setup

```sh
# .zshrc
ZSH_THEME="avil/avil"
```

Enjoy =)

## Git prompt

The Git segment shows the branch and short commit hash. Detached HEAD shows
only the hash; a new repository without commits shows only the branch name.

| Symbol | Meaning |
| --- | --- |
| `⚔` | Conflicted files (excluded from other file counters) |
| `↑` | Commits in HEAD not reachable from any remote-tracking branch |
| `↓` | Commits in `origin/<current branch>` missing from HEAD |
| `●` / `⊗` / `⊖` | Staged modifications / additions / deletions |
| `+` / `⊝` | Unstaged modifications / deletions |
| `?` | Untracked files, including individual files inside directories |
| `↔` | Renamed files |
| `≡` | Stash entries |
| `w` | Linked worktree |
| `⏱️` | Tail produced by a background cache refresh |

A file modified both in the index and working tree contributes to both counters.
BISECT, MERGE, CHERRY, REVERT and REBASE indicate an ongoing Git operation.
The right prompt shows `✔` on success or the previous command's nonzero exit code.

### Remote status and cache limitations

Currently `↑` and `↓` are **not a pair relative to the configured upstream**:
`↓` assumes `origin` and the same branch name, while `↑` considers all remotes.
Unavailable counts are omitted. No network fetch is performed; remote status
reflects locally stored refs, updated by your own fetch/pull operations.

When synchronous rendering exceeds 400 ms, the theme saves the tail in the Git
directory and refreshes it in the background on subsequent prompts. This timing
requires `zsh/datetime` to be loaded (for example, `zmodload zsh/datetime` in
`.zshrc` before loading the theme).

The branch/detached hash is live, but the cached tail can lag. An update appears
on the next prompt after it completes; there is no fixed freshness guarantee or
automatic redraw. Switching HEAD can temporarily show a tail from the previous
state. Concurrent terminals can still race while refreshing the shared cache.
Use `git status` when an authoritative current state is needed.

## Colors

The theme supplies defaults for `LSCOLORS`, `LS_COLORS` and
`ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE` only when they are unset. Set them before loading
the theme to override the defaults; explicitly empty values are also preserved.

## Checks and timing

From the theme directory:

```sh
zsh -f tests/git-status-tail.zsh
zsh -f tests/theme-settings-head.zsh
```

To measure synchronous Git-segment rendering in any repository:

```sh
zsh -f /path/to/avil-zsh-theme/tests/benchmark.zsh
```

This reports the mean of 10 runs without reading or writing the prompt cache;
it does not measure cache hits or terminal redraws. The older `test_speedup.sh`
remains a separate demonstration, not a benchmark of this theme.


