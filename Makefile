#!/bin/bash

FILES= \
	.bashrc \
	.ctags \
	.cvsignore \
	.cvsrc \
	.gdbinit \
	.gdbinit.python \
	.gitconfig \
	.kshrc \
	.mailcap \
	.mplayer \
	.muttrc \
	.plan \
	.profile \
	.tmux.conf \
	.zlogin \
	.zshrc

all: deploy deploy-vim

deploy:
	$(foreach file,$(FILES),ln -sf $(PWD)/$(file) ~/;)
	ln -sf $(PWD)/com.googlecode.iterm2.plist ~/Library/Preferences/

vimrc_repo?= git@github.com:proger/vimrc.git
deploy-vim:
	-cd ~; git clone $(vimrc_repo) .vim
	cd ~/.vim; git pull --rebase; $(MAKE)

USER?= proger
osx-fixtank:
	mount -uw /
	launchctl load /System/Library/LaunchDaemons/com.apple.opendirectoryd.plist
	dscl . /Users/$(USER) -change NFSHomeDirectory /Users/$(USER) /tank/$(USER)
	mv Users tank
	ln -s tank Users

.PHONY: all deploy deploy-vim osx-fixtank
