# proger's zshrc
# generic

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

_alias	up		'source ~/.zlogin && source ~/.zshrc'

#_alias	ll		ls -lhF --group-directories-first
_alias	ll		ls -lhFG
_alias	la		ll -as
_alias	lt		ll -ut
#_alias	lld		ll -cr
_alias	lld		ll -tr
_alias	lf		ls -f
_alias	.		pwd
_alias	..		cd ..
_alias	df		df -h
_alias	du		du -h
#_alias	md		mkdir -p
_alias	rd		rm -ri
_alias	rm		rm -i
_alias	mv		mv -i
_alias	cp		cp -i
_alias	tail		tail -n40
_alias	d		date
_alias	j		jobs -l
_alias	di		dirs -v		# use cd -<tab>
_alias	cl		clear
_alias	grab		sudo chown -R $USER

_alias	g		egrep --color -i
#_alias	g		pcregrep -i --color

_alias	fs		fossil
_alias	rsync		rsync -hv --progress

_alias	gdb		gdb -q
_alias	py		ipython --no-banner --no-confirm-exit
_alias	pipi		pip install --install-option="--prefix=$HOME/.local"
_alias	hs		ghci
#_alias	ocaml		ledit -x -h ~/.ocamlhist ocaml
_alias	ljdb		java -cp /usr/lib/jline/jline.jar:/usr/lib/jvm/java-6-openjdk/lib/tools.jar jline.ConsoleRunner com.sun.tools.example.debug.tty.TTY

_alias	ifconfig	sudo ifconfig

_alias	shosts		vim ~/.ssh/known_hosts
_alias	hosts		sudo vim /etc/hosts

#_alias	gentags		exctags -R --c-kinds=+p --fields=+iaS --extra=+q
_alias	gentags		ctags -R --format=2

_alias	tcpdumpv	sudo tcpdump -vv -X -w savedump -s 2048
_alias	vnc		vncviewer -compresslevel 9 -quality 1 -bgr233
_alias	xd		'export DISPLAY=:0.0; xset dpms force on'
_alias	koi		luit -encoding 'KOI8-R' --
_alias	dict		sdcv --utf8-output

_alias	qemul		qemu -nographic -serial telnet::4444,server
_alias	qemul64		qemu-system-x86_64 -nographic -serial telnet::4444,server

_alias	htmlesc		'perl -pi -e '\''s/\<[^\>]*\>//g'\'
_alias	compute		'while true; do head -n 100 /dev/urandom; sleep .1; done | hexdump -C | grep "ca fe"'
_alias	rainbow		'yes "$(seq 231 -1 16)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .02; done'
_alias	randip		jot -r -s "." 4 1 255
_alias	pics		'feh (*/)#^*-s.*(.)'

_alias	pg		'ps axuww | g'
#_alias  vim             emacs

_alias	ck		sha512sum

_alias	xmlp		tidy -xml -q --escape-cdata y

_alias	rtmp		rtmpdump -o /dev/null -V -v -r

_alias	fabh		fab -w --abort-on-prompts --linewise -H

_alias	wow		git status
_alias	very		git
_alias	such		git


clean() {
	export PS1="%% "
	unset RPS1
}

mkcd() {
	mkdir $1
	echo $1
	cd $1
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
	cat ~/.ssh/authorized_keys | ssh $* 'mkdir -p .ssh; cat >> .ssh/authorized_keys'
}

vim() {
	if [ $# -eq 1 -a X"${1%%:*}" != X"$1" ]; then
		# split /path/to/file/file.c:12345 to vim args
		command $0 `echo $1 | awk -F: '{print $1, "+"$2}'`
	else
		command $0 $*
	fi
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
	local dbpath="$HOME/local/db"

	[ X"$tmux" = X"" ] && {
		[ -f $dbpath/mongod.lock ] && {
			ps -A | grep mongod
			echo 'about to remove lock and repair'
			read
			rm -f $dbpath/mongod.lock
			command env LC_ALL=C mongod --dbpath $dbpath --repair
		}
		tmux new -s mongo "env LC_ALL=C mongod --master \
			--dbpath $dbpath --rest ${argv[2, -1]}"
	} || {
		tmux at -t mongo
	}
}

pg_grep() {
	local db=$1
	local pat=$2
	local table

	for table in $(psql -Atc '\dt' -d $db | awk -F\| '{print $2}'); do
		psql -Atc "select * from $table" -d $db | grep $pat | sed "s/^/$table:/"
	done
}

graph() {
	local arg="${argv[3, -1]}"
	local file="`basename $2`.png"
	$1 -Tpng "$2" $arg > "$file"
	open "$file"
}

agent() {
	ssh-agent | grep export > ~/.ssh_agent
	source ~/.ssh_agent
	ssh-add ~/.ssh/id_rsa
}

# background automatically
zz() {
	echo $*
	$* >& /dev/null &!
}

ansibleout() {
	local dir="$1"
	for f in $dir/*; do
		json -a -C stdout stderr < $f > $f.out;
		echo $f.out;
	done
}

gpgwho() {
	local filename="$1"
	gpg --batch --decrypt --list-only --status-fd 1 "$filename" 2>/dev/null \
		| awk '/ENC_TO/ {print $3}' \
		| xargs -t -n1 gpg --list-keys
}

nix-prefetch-git-here() {
	$(nix-instantiate --eval -E '<nixpkgs>')/pkgs/build-support/fetchgit/nix-prefetch-git file://$(pwd) 2>&1 \
		| awk '/^git revision is/ { print "    rev = \""$4"\";"; } /^hash is/ {print "    sha256 = \""$3"\";"; }'
}


# suffix aliases
alias -s {jpg,jpeg,png,gif,tiff,bmp}='feh'
alias -s {mp3,wav,avi,mpeg,ogg,mpg}='mplayer'
alias -s {pdf,ps}='mupdf'
alias -s {odt,odp,ods,doc,xls,docx}='soffice'
alias -s djvu='djview4'

alias -s log='tail -f'

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
bindkey	-e
bindkey	"^[n"	backward-word
bindkey	"^[m"	forward-word

# -a: 	vicmd
# -v:	viins
#bindkey -a	"/"	history-incremental-search-backward
#bindkey	-a	"?"	history-incremental-search-forward
#bindkey	-v	"^['"	insert-last-word
#bindkey	-v	"^W"	backward-kill-word
#bindkey	-v	"^R"	history-incremental-search-backward
#bindkey -v	"^A"	beginning-of-line
#bindkey -v	"^E"	end-of-line
#bindkey	-v	"^[n"	backward-word
#bindkey	-v	"^[m"	forward-word
#bindkey -v

# edit command in $EDITOR
zle -N edit-command-line
bindkey		'\C-x\C-e'	edit-command-line

# history
export	HISTIGNORE="&:ll:ls:[bf]g:exit:reset:cl:clear:cd:..:halt"
export	HISTSIZE=25000
export	SAVEHIST=25000
export	HISTFILE=~/.zshistory
export	DIRSTACKSIZE=30

setopt	APPEND_HISTORY
setopt	INC_APPEND_HISTORY
setopt	EXTENDED_HISTORY
setopt	HIST_IGNORE_DUPS
setopt	HIST_IGNORE_SPACE
setopt	HIST_REDUCE_BLANKS
setopt	HIST_SAVE_NO_DUPS
setopt	HIST_VERIFY
setopt	HIST_FCNTL_LOCK
#setopt	SHARE_HISTORY
setopt	PROMPT_SUBST

# completion
zle -N incremental-complete-word
zle -N insert-files
zle -N predict-on

# case-insensitive matching
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
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
#zstyle ':completion:*' menu select=long-list select=0

# kill
zstyle ':completion:*:processes' menu yes select
zstyle ':completion:*:processes' command "ps -aU$USER"

# no cvs junk
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

zstyle ':completion:*:*:vi*:*' verbose yes
#zstyle ':completion:*:*:vi*:*' menu select=long-list select=0
zstyle ':completion:*:*:vi*:*' file-sort modification
zstyle ':completion:*:*:vi*:*' ignored-patterns '(*.(o|class|pyc)|CVS|a.out)'

# rm protection
#zstyle ':completion:*:*:rm*:*' ignored-patterns '*' # XXX: ?!?

# ssh
zstyle ':completion:*:scp:*' tag-order \
   files 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *' users

zstyle ':completion:*:ssh:*' hosts ${${(s:,:)${(j:,:)${${(u)${(f)"$(<~/.ssh/known_hosts)"}%%[, |#]*}%"]"*}##*"["}}}

# man stuff
zstyle ':completion:*:manuals' separate-sections true

# cc
compctl -/g "*.[cCoa]" -x 's[-I]' -/ - \
	's[-l]' -s '${(s.:.)^LD_LIBRARY_PATH}/lib*.a(:t:r:s/lib//)' -- cc gcc g++ c++ clang clang++

# colors!
#export	ZLS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jpg=01;35:*.png=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.png=01;35:*.mpg=01;35:*.avi=01;35:*.mkv=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:'
#export	LS_COLORS=$ZLS_COLORS
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

ps1_vcs() {
	[ -f .svn/entries ] && {
		ent=($(<.svn/entries))
		echo -n ":$cyan${ent[3]}"
	} || {
		ref=$(git symbolic-ref HEAD 2> /dev/null) || return
		echo -n ":$cyan${ref#refs/heads/}"
	}
}

parent=$(basename ${$(ps -o comm= -p $PPID)#-})
case $parent in
	xterm|urxvt|tmux|sshd|sshd:*|sudo|login|gnome*) parent="";;
	*) parent="${CYAN}${parent}${NOCOLOR} ";;
esac

case ${USER:-$LOGNAME} in
	proger|root) user="";;
	*) user=" ${GREEN}%n ";;
esac

#export	PS1="$parent${white}%m$user%(0?.. ${red}%? )${GRAY}%#$NOCOLOR "
export	PS1="$parent%m$user%(0?.. ${red}%? )${GRAY}%#$NOCOLOR "
export	PS2="%_> "
export	RPS1="%(1j.${green}j%j${NOCOLOR}.) ${blue}%3~\$(ps1_vcs)$NOCOLOR"
#export	RPS1="%(1j.${green}j%j${NOCOLOR}.)"

case $TERM in
	xterm*|*rxvt*)
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

[ -f $HOME/.todo ] && < $HOME/.todo

# vim: foldmethod=marker
