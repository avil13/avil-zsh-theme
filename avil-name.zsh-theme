# AVIL ZSH Theme

source ./lib/functions.zsh

# settings
typeset +H _current_dir="%{$FG[014]%}%0~%{$reset_color%}"
typeset +H _return_status=" %(?.✔.%{$fg[red]%}%?%f)"
typeset +H _hist_no="%{$fg[grey]%}%h%{$reset_color%}"
typeset +H _PS_ICON='❯'

if [[ $UID == 0 || $EUID == 0 ]]; then
    typeset +H _PS_ICON="%{$fg_bold[red]%}#%{$reset_color%}"
fi

RPROMPT='${_return_status}'
PROMPT='%F{green}%n@%m%{$reset_color%} $(_get_git_avil_prompt)$(_folder_path_icon $(pwd))${_current_dir}
%{%(!.%F{red}.%F{blue})%}${_PS_ICON}%{$reset_color%} '

PROMPT2='%{%(!.%F{red}.%F{white})%}◀%{$reset_color%} '

MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
