INPUTRC=~/.config/bash/inputrc
HISTFILE=~/.local/share/bash/bash_history
HISTSIZE=-1
HISTFILESIZE=-1
HISTCONTROL="ignorespace:ignoredups"
export LS_COLORS='or=41'
#LS_COLORS='di=32:fi=33:ln=94:or=41:ex=91'
#export LS_COLORS

shopt -s histverify
shopt -s extglob
shopt -s globstar
shopt -s cdspell
shopt -s direxpand
shopt -s dirspell
shopt -s histappend

source /usr/share/git/completion/git-prompt.sh
source ~/.config/bash/bash_aliases
source /etc/profile.d/vte.sh
source ~/.config/bash/bash_functions
source /usr/share/fzf/completion.bash

export FZF_COMPLETION_TRIGGER='**'

complete -o bashdefault -o default -F _fzf_path_completion mpv
complete -o bashdefault -o default -F _fzf_path_completion vim
complete -o bashdefault -o default -F _fzf_path_completion zathura

# Key bindings
bind -x '"\C-B": "bookmark ."'
bind -x '"\C-H": "hist"'

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
PROMPT_NAME_STYLE="$(tput setaf 23)$(tput bold)"
PROMPT_WDIR_STYLE="$(tput setaf 22)$(tput bold)"
PROMPT_RED_BOLD="$(tput setaf 1)$(tput bold)"
PROMPT_RED="$(tput setaf 1)"
PROMPT_BOLD="$(tput bold)"
PROMPT_COLOR="$(tput setaf 24)"
RESET="$(tput sgr0)"
PS0='\[$RESET\]'
PS1='\[$PROMPT_NAME_STYLE\]\u\[$RESET\]:\[$PROMPT_WDIR_STYLE\]\W/\[$RESET\]$(__git_ps1 " (%s)") \$\[$PROMPT_COLOR\] '
