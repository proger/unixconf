#!/bin/bash

CONF_ESSENTIAL="
.bashrc
.cvsignore
.cvsrc
.ctags
.gdbinit
.gitconfig
.mailcap
.muttrc
.plan
.profile
.shrc
.kshrc
.zlogin
.zshrc
"

CONF_X11="
.Xdefaults
.Xmodmap
.cwmrc
.fonts.conf
.gtkrc-2.0
local/bin/ceval
local/bin/oimap
local/bin/xkbd
local/bin/genssltriple
local/bin/dhcp-lease-list
local/bin/convmv
local/bin/mp
local/bin/isoproc.py
.mplayer/config
.rtorrent.rc
.terminfo
.vimperatorrc
.xinitrc
"

CONF_DEV="
.asciidoc.conf
.cpan/CPAN/MyConfig.pm
.ipython/ipythonrc
.mgprc
.ocamlfind.conf
"

CONF_NETBSD="
../etc/mk.conf
"

CONF_ALL="$CONF_ESSENTIAL $CONF_X11 $CONF_DEV"

DIST=`dirname $0`
ABSDIST=`(cd $DIST; pwd)`

persist() {
	(cd $HOME; pax -rw -v ${1:-$CONF_ALL} $ABSDIST/)
}

deploy() {
	(cd $ABSDIST; pax -rw -v ${1:-$CONF_ALL} $HOME/)
}

print() {
	group=${1:-ALL}
	var=\$CONF_$group
	eval echo $var
}

cmd=$1; shift
$cmd $*
