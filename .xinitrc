#!/bin/sh

#rm -f ~/*.core
#pgrep aucat || (aucat -l -r 48000 &)
#make vgamain
xmodmap ~/.Xmodmap
grep -v '^#' ~/.Xdefaults | xrdb -merge -
#xgamma -gamma 0.9
xsetroot -solid '#161e25'
xsetroot -cursor_name left_ptr
xset m 2 1
xset b off
#xset +fp /usr/share/fonts/local
#xset fp+ /usr/local/share/ghostscript/fonts
xkbd
#root-tail -f -g 1000x740+10+5 --shade /var/log/xferlog,green /var/log/authlog,red /var/log/messages,white
#eval $(cat ~/.fehbg)

#autocutsel -fork &
#autocutsel -selection PRIMARY -fork &

#env > ~/.startx.env

/usr/lib/gnome-settings-daemon

#exec env LC_CTYPE=en_US.UTF-8 awesome 2>&1 >> .awesome.errors
#ion3
#wmaker
#openbox
#pekwm
#enlightenment_start
#/usr/local/e/bin/enlightenment_start 
#make -f /home/proger/Makefile vgamain
#/usr/local/e/bin/enlightenment_start -profile standard
#/usr/local/e/bin/enlightenment_start 
#/usr/local/bin/fvwm
cwm || xterm
#openbox || xterm
#fvwm
