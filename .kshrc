# proger's kshrc

alias ll="ls -lhF"
alias lo="ll -o"
alias la="lo -a"
alias du="du -h"
alias df="df -h"
alias ..="cd .."
alias grab="sudo chown -R ${USER} ."
alias fgrab="sudo chown ${USER}"
alias md="mkdir -p"
alias tail="tail -n40"
alias head="head -n40"
alias g="egrep -i"
alias cl="clear"
alias mmesg="tail -f /var/log/messages"
alias pk='sudo pkill'
alias pkg_add="sudo pkg_add"
alias pkg_delete="sudo pkg_delete"
alias top="top -CT"
alias pfctl="sudo pfctl"
alias pp='ps axuwwwk'
alias mdmesg='tail -f /var/log/daemon'
alias isa='sudo ipsecctl -sa'
alias ipsecreset='sudo pkill isakmpd; sudo isakmpd -4Kv; sudo ipsecctl -vf /etc/ipsec.conf'
alias pkglist="pkg_info -q | perl -pi -e 's/([\w\-]+)-([\d\.pvs]+)-?([\w_]+)?/\1--\3/g' | sort -u"
alias tlog='sudo tcpdump -r ~/tracklog | tail'

mkcd() {
        mkdir -p $1 && cd $1
}

# prompt
normal="\[\e[0m\]"
nobg="m\]"
black="\[\e[0;30$nobg"
redfaint="\[\e[0;31$nobg"
greenfaint="\[\e[0;32$nobg"
brownfaint="\[\e[0;33$nobg"
bluefaint="\[\e[0;34$nobg"
purplefaint="\[\e[0;35$nobg"
cyanfaint="\[\e[0;36$nobg"
greyfaint="\[\e[0;37$nobg"
grey="\[\e[1;30$nobg"
red="\[\e[1;31$nobg"
green="\[\e[1;32$nobg"
yellow="\[\e[1;33$nobg"
blue="\[\e[1;34$nobg"
pink="\[\e[1;35$nobg"
cyan="\[\e[1;36$nobg"
white="\[\e[1;37$nobg"

if [ ${TERM%%-*} = "xterm" ]; then
        HOST=`hostname`
        tty=`basename $(tty) | sed 's/tty//g'`
        
        WLS='\033]2;'; WLE='\007'
        label() { printf "${WLS}$*${WLE}"; }
        alias stripe='label "$HOST:$tty:$PWD"'
        
        wcd() {
		\cd "$@"
		if [ X"$TMARK" != X"" ]; then
        		label "$HOST:$tty:$PWD -- $TMARK"
		else
        		label "$HOST:$tty:$PWD"
		fi
	}
        alias cd=wcd

	wcd
fi

export PS1="$blue\h $blue\w $red\$? $white% $normal"

# motd
[[ -f ~/.motd ]] && cat ~/.motd

# behaviour
set -o emacs
set +o emacs-usemeta
#set -o vi
bind '^[,'=backward-word
bind '^[.'=forward-word
bind '^[[A'=up-history
bind '^[[B'=down-history

im() {
        IM_SESSION="im"
        IM_COMMAND="irssi"
	export TMARK="im"

        local tmux="`tmux ls | egrep "^$IM_SESSION"`"

	wcd
        if [ X"$tmux" = X"" ]; then
                tmux new -s $IM_SESSION $IM_COMMAND $*
                #tmux new -s $IM_SESSION $IM_COMMAND \; \
		#	neww -n silc silc
        else
                tmux at -t $IM_SESSION $*
        fi
	wcd
}

alias koim='luit -encoding "KOI8-R" -- tmux attach -t im'

# vim: ft=sh
