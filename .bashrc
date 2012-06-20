#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ll -a'
PS1='\h\$ '

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
