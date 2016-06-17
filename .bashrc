#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ll='ls -lhG'
alias la='ll -a'
alias lock='open -a /System/Library/Frameworks/ScreenSaver.framework//Versions/A/Resources/ScreenSaverEngine.app'
alias g='grep -i'
alias ..='cd ..'
alias e='emacsclient -t'

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend

_my_prompt_command() {
    prompt_status="$? "; if [[ $prompt_status == "0 " ]]; then prompt_status=; fi
    #history -a; history -c; history -r;
}

PROMPT_COMMAND="_my_prompt_command; $PROMPT_COMMAND"
PS1='$prompt_status\w% '
export EDITOR="emacsclient -nc"

export PATH=$HOME/local/bin:$HOME/.opam/system/bin:$HOME/.local/bin:/usr/local/texlive/2015/bin/x86_64-darwin:/Users/vladki/.gem/ruby/2.0.0/bin:$HOME/Library/Python/2.7/bin:$PATH

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

complete -C aws_completer aws

export PYTHONPATH=/Users/vladki/Library/Python/2.7/lib/python/site-packages

export HOMEBREW_NO_ANALYTICS=1

# eval `opam config env`
alias evalopam='eval `opam config env`'
