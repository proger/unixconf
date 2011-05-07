# proger's zshrc

# modules
autoload	-U zargs
autoload	-U compinit promptinit
compinit
autoload	-U incremental-complete-word
autoload	-U insert-files
autoload	-U predict-on
promptinit
zmodload	zsh/complist
autoload	edit-command-line

# aliases
_alias() {
	local arg="${argv[2, -1]}"
	alias $1=$arg
}

_alias	ls		gls --color=auto
_alias	ll		ls -lhF
_alias	la		ls -lashF
_alias	lt		ls -lut
#_alias	lld		ls -lhF -cr
_alias	lld		ls -lhF -tr
_alias	lf		ls -f
_alias	.		pwd
_alias	..		cd ..
_alias	df		df -h
_alias	du		du -h
_alias	md		mkdir -p
_alias	rd		rm -ri
_alias	rm		rm -i
_alias	mv		mv -i
_alias	cp		cp -i
_alias	tail		tail -n40
_alias	d		date
_alias	f		finger
_alias	j		jobs -l
_alias	di		dirs -v		# use cd -<tab>
_alias	cl		clear
_alias	lock		lock -pn
_alias	mmesg		tail -f /var/log/messages
_alias	grab		sudo chown -R $USER

_alias	up		'source ~/.zlogin && source ~/.zshrc'

_alias	g		egrep --color -i
#_alias	g		pcregrep -i --color
_alias	a		ack -au --nobinary
_alias	ackmi		ack --ignore-dir=arch

_alias	fs		fossil
_alias	rsync		rsync -hv --progress

_alias	py		ipython
_alias	hs		ghci
_alias	pl		~/local/perl/bin/re.pl
_alias	ilua		env \
			LUA_CPATH="$HOME/dev/lua/ilua/\?.so;$LUAPKG/\?/\?.so" \
			LUA_PATH="./\?.lua;$LUAPKG/\?/\?.lua" \
			~/dev/lua/ilua/ilua.lua -Lreadline
_alias	gdb		gdb -q

_alias	pkg_add		sudo pkg_add -v
_alias	pkg_delete	sudo pkg_delete -v
_alias	top		top -ct
_alias	psmem		'ps -k vsize -O user,pid,%cpu,%mem,vsz,rss -a | \head -n $LINES'
_alias	mount_nfs	sudo mount_nfs -iTs					# tcp soft intr
_alias	vnconfig	sudo vnconfig

_alias	halt		sudo halt -p
_alias	shosts		vim ~/.ssh/known_hosts
_alias	hosts		sudo vim /etc/hosts

_alias	gentags		exctags -R --c-kinds=+p --fields=+iaS --extra=+q

_alias	tcpdumpv	sudo tcpdump -vv -X -w savedump -s 2048
_alias	ku		cu -l /dev/cuaU0 -s 19200
_alias	vnc		vncviewer -compresslevel 9 -quality 1 -bgr233
_alias	xd		'export DISPLAY=:0.0; xset dpms force on'
_alias	koi		luit -encoding 'KOI8-R' --

_alias	qemul		qemu -nographic -serial telnet::4444,server
_alias	qemul64		qemu-system-x86_64 -nographic -serial telnet::4444,server

_alias	htmlesc		'perl -pi -e '\''s/\<[^\>]*\>//g'\'
_alias	compute		'while true; do head -n 100 /dev/urandom; sleep .1; done | hexdump -C | grep "ca fe"'
_alias	randip		jot -r -s "." 4 1 255
_alias	pics		'feh (*/)#^*-s.*(.)'

# generic functions {{{
mkcd() {
	mkdir $1
	echo $1
	cd $1
}

pp() {
	if [ $# -ge 1 ]; then
		ps -Asxw -o 'pid,wchan,stat,tt,time,lname,command' | g $*
	else
		ps -Axs -o 'pid,user,ni,%cpu,vsz,rss,wchan,tt,time,lname,command'
	fi
}

svndiff() {
	svn diff $* | vim -R -
}

gitdiff() {
	git diff $* | vim -R -
}

cvsdiff() {
	cvs diff $* | vim -R -
}

cs() {
	cvs diff $* | g '^(\?|Index)'
}

# emulate gnu sed -i
# $1 - command
# $2 - file
sedi() {
        local tmpf=`mktemp /tmp/sedi_tmp.XXXXXX`

        sed $1 $2 > $tmpf

        cat $tmpf > $2
        rm -f $tmpf
}

authcopy() {
	cat ~/.ssh/authorized_keys | ssh $* 'mkdir -p .ssh; cat > .ssh/authorized_keys'
}

umount() {
	[ $1 = "." ] && {
		opwd=$PWD
		cd ..
		sudo /sbin/umount $opwd
	} || {
		sudo /sbin/umount $*
	}
}

vim() {
	[ $# -eq 1 -a X"${1%%:*}" != X"$1" ] && {
		# split /path/to/file/file.c:12345 to vim args
		command vim `echo $1 | awk -F: '{print $1, "+"$2}'`
	} || {
		command vim $*
	}
}
# }}}

# osdep functions {{{
_startx() {
	pgrep startx && wsconsctl display.focus=4 \
		|| (rm -f ~/.Xauthority*; \
			/usr/X11R7/bin/startx >& ~/.startx.out &)
	lock
}

pk() {
	ps axwws | g ${argv[-1]}
	read
	sudo pkill $*
}

ex() {
	local old_dirs current_dirs lower
	lower=${(L)1}
	old_dirs=( *(N/) )
	if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
		tar zxfv $1
	elif [[ $lower == *.gz ]]; then
		gunzip $1
	elif [[ $lower == *.tar.bz2 || $lower == *.tbz || $lower == *.tbz2 ]]; then
		bunzip2 -c $1 | tar xfv -
	elif [[ $lower == *.bz2 ]]; then
		bunzip2 $1
	elif [[ $lower == *.zip ]]; then
		unzip $1
	elif [[ $lower == *.rar ]]; then
		unrar x $1
	elif [[ $lower == *.tar ]]; then
		tar xfv $1
	else
		print "unknown archive type: $1"
		return 1
	fi
	# Change in to the newly created directory, and
	# list the directory contents, if there is one.
	current_dirs=( *(N/) )
	for i in {1..${#current_dirs}}; do
		if [[ $current_dirs[$i] != $old_dirs[$i] ]]; then
			cd $current_dirs[$i]
			ls
			break
		fi
	done
}
compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.tbz2 *.zip *.rar *.tar"' ex

isoburn() {
	sudo growisofs -dvd-compat -Z /dev/rcd0c=$1
}

vol() {
	if [ $# -eq 1 -a "$1" = "-" ]; then
                mixerctl -va
        elif [ $# -eq 1 ]; then
                mixerctl -w outputs.master=$1 || \
			mixerctl -w outputs.lineout=$1
        else
                mixerctl outputs.master
        fi
}

ncmpc() {
	pgrep mpd >/dev/null || mpd /shared/audio/mpdconf
	/usr/pkg/bin/ncmpc $*
}

dict() {
	sdcv --utf8-output $*
}

im() {
        IM_SESSION="im"
        IM_COMMAND="irssi"
        export TMARK="im"

        local tmux="`tmux ls | egrep "^$IM_SESSION"`"

        if [ X"$tmux" = X"" ]; then
                tmux new -s $IM_SESSION $IM_COMMAND
        else
                tmux at -t $IM_SESSION
        fi
}

mongod() {
        local tmux="`tmux ls | egrep '^mongo'`"

        [ X"$tmux" = X"" ] && {
                tmux new -s mongo \
			"mongod --master \
			--dbpath $HOME/local/db \
			--rest ${argv[2, -1]}"
	} || {
                tmux at -t mongo
	}
}

graph() {
	local arg="${argv[3, -1]}"
	local file="`basename $2`.png"
	$1 -Tpng "$2" $arg > "$file"
	feh "$file"
}
# }}}

# background automatically
zz() {
	echo $*
	$* >& /dev/null &!
}

# suffix aliases
alias -s {jpg,jpeg,png,gif,tiff,bmp}='feh'
alias -s {mp3,wav,avi,mpeg,ogg,mpg}='mplayer'
alias -s {pdf,ps}='mupdf'
alias -s {odt,odp,ods,doc,xls,docx}='soffice'
alias -s djvu='djview3'

alias -s	log='tail -f'

# zsh options
setopt	NO_HUP
setopt	CHECK_JOBS
setopt	LONG_LIST_JOBS
setopt	NO_BEEP
setopt	NO_HASH_CMDS
setopt	NO_HASH_DIRS
setopt	AUTO_PUSHD PUSHD_MINUS PUSHD_IGNORE_DUPS
setopt	EXTENDED_GLOB		# weird & wacky pattern matching
setopt	COMPLETE_IN_WORD	# not just at the end
setopt	ALWAYS_TO_END		# when complete from middle, move cursor
setopt	CORRECT
setopt	AUTO_LIST
setopt	NO_LIST_PACKED		# no compact completion lists
setopt	AUTO_CD
setopt	AUTO_MENU
setopt	INTERACTIVE_COMMENTS
setopt	PROMPT_SUBST
setopt	MULTIBYTE
#unsetopt MULTIBYTE

limit	coredumpsize 10m

# keybinds
bindkey -d
WORDCHARS=${WORDCHARS//[\&\=\/\;\!\#\%\{\.]}	# honor more word separators

# emacs
#bindkey	-e
#bindkey	"^[n"	backward-word
#bindkey	"^[m"	forward-word

# -a: 	vicmd
# -v:	viins
bindkey -a	"/"	history-incremental-search-backward
bindkey	-a	"?"	history-incremental-search-forward
bindkey	-v	"^['"	insert-last-word
bindkey	-v	"^W"	backward-kill-word
bindkey	-v	"^R"	history-incremental-search-backward
bindkey -v	"^A"	beginning-of-line
bindkey -v	"^E"	end-of-line
bindkey	-v	"^[n"	backward-word
bindkey	-v	"^[m"	forward-word
bindkey -v

# edit command in $EDITOR
zle -N edit-command-line
bindkey		"^N"	edit-command-line

# history
export	HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:..:halt"
export	HISTSIZE=25000
export	SAVEHIST=25000
export	HISTFILE=~/.zshistory
export	DIRSTACKSIZE=30

setopt	APPEND_HISTORY
setopt	INC_APPEND_HISTORY
setopt	EXTENDED_HISTORY
#setopt	HIST_IGNORE_DUPS
setopt	HIST_IGNORE_SPACE
setopt	HIST_REDUCE_BLANKS
setopt	HIST_SAVE_NO_DUPS
setopt	HIST_VERIFY
setopt	HIST_FCNTL_LOCK
#setopt	SHARE_HISTORY

# completion
zle -N incremental-complete-word
zle -N insert-files
zle -N predict-on

# matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# formatting and messages
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' substitute 0
zstyle ':completion:*' original true
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# use grouped completion variants by type
#zstyle ':completion:*' group-name ''
zstyle ':completion:*' file-sort name
# use menus
zstyle ':completion:*' menu select=long-list select=0

# kill
zstyle ':completion:*:processes' menu yes select
zstyle ':completion:*:processes' command "ps -aU$USER"

# no cvs junk
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zstyle ':completion:*:*:vi*:*' verbose yes
zstyle ':completion:*:*:vi*:*' menu select=long-list select=0
zstyle ':completion:*:*:vi*:*' file-sort modification
zstyle ':completion:*:*:vi*:*' ignored-patterns '(*.(o|class|pyc)|CVS)'

# rm protection
#zstyle ':completion:*:*:rm*:*' ignored-patterns '*' # XXX: ?!?

# ssh
zstyle ':completion:*:scp:*' tag-order \
   files 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *' users

zstyle ':completion:*:vnc*:*' _hosts

# man stuff
zstyle ':completion:*:manuals' separate-sections true

# cc
compctl -/g "*.[cCoa]" -x 's[-I]' -/ - \
	's[-l]' -s '${(s.:.)^LD_LIBRARY_PATH}/lib*.a(:t:r:s/lib//)' -- cc gcc g++

# colors!
export	ZLS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.mkv=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:'
export	LS_COLORS="$ZLS_COLORS"
zstyle	':completion:*' list-colors ${(s.:.)ZLS_COLORS}
zstyle	':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=01;36=31"

# prompt
# colors {{{
local red="%{"$'\e[1;31m'"%}"
local RED="%{"$'\e[0;31m'"%}"
local cyan="%{"$'\e[1;36m'"%}"
local CYAN="%{"$'\e[0;36m'"%}"
local blue="%{"$'\e[1;34m'"%}"
local BLUE="%{"$'\e[0;34m'"%}"
local green="%{"$'\e[1;32m'"%}"
local GREEN="%{"$'\e[0;32m'"%}"
local magenta="%{"$'\e[1;35m'"%}"
local MAGENTA="%{"$'\e[0;35m'"%}"
local yellow="%{"$'\e[1;33m'"%}"
local YELLOW="%{"$'\e[0;33m'"%}"
local gray="%{"$'\e[1;30m'"%}"
local GRAY="%{"$'\e[0;37m'"%}"
local white="%{"$'\e[1;37m'"%}"
local NOCOLOR="%{"$'\e[0m'"%}"
local NEWLINE="%{"$'\e[80D'"%}"
# }}}

export	PS1="${white}%m ${blue}%3~ ${red}%? ${GRAY}%#$NOCOLOR "
export	PS2="%_> "
unset	RPS1

export	__LASTDATE=""	# TODO

case $TERM in
	xterm*|rxvt*)
		precmd() {
			print -Pn "\033]0;%M:%l:%~\a"
		}
		preexec() {
			print -Pn "\033]0;%M:%l:%~ -- $1\a"
		}
	;;
	screen*)
		precmd() {
			print -Pn "\ek%~\e\\"
		}
		preexec() {
			local CMD=${1[(wr)^(*=*|sudo|-*)]}
			print -n "\ek$CMD\e\\"
		}
	;;
esac

# vim: foldmethod=marker
