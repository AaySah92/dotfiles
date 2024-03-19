#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval "$(starship init bash)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export TERM='xterm-256color'

(cat ~/.cache/wal/sequences &)

alias p='sudo pacman'
alias logout='hyprctl dispatch exit'
# alias wifi='nmcli device wifi connect VM1696793 --ask'
alias wifi='nmcli con up id VM1696793'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
. /usr/share/autojump/autojump.bash
# neofetch

