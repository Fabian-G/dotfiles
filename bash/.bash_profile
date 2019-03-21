[[ $- == *i* ]] && source "$HOME/.bashrc"
source "$HOME/.config/bash/bashenv"

[[ $(tty) == "/dev/tty1" ]] && exec startx
