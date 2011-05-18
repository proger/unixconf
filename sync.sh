#!/bin/sh

CONF_ESSENTIAL="
.cvsignore
.cvsrc
.gitconfig
.muttrc
.plan
.profile
.shrc
.zlogin
.zshrc
"

CONF_X11="
.Xdefaults
.Xmodmap
.cwmrc
.fehrc
.fonts.conf
.gtkrc-2.0
local/bin/oimap
local/bin/xkbd
.mplayer/config
.rtorrent.rc
.terminfo
.vimperatorrc
.vimperatorrc36
.xinitrc
"

CONF_DEV="
.asciidoc.conf
.cpan/CPAN/MyConfig.pm
.ipython/ipythonrc
.mgprc
.ocamlfind.conf
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
