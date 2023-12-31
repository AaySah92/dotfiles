#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

(cat ~/.cache/wal/sequences &)

alias vi='nvim'
alias p='sudo pacman'
alias logout='hyprctl dispatch exit'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
. /usr/share/autojump/autojump.bash
neofetch
