#!/usr/bin/env make -f -

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
	#
	install -d ~/local/bin
	ln -sf $(PWD)/bin/unzipq ~/local/bin/
	ln -sf $(PWD)/bin/getplaylist ~/local/bin/
	ln -sf $(PWD)/bin/mknixvm  ~/local/bin/
	ln -sf $(PWD)/bin/tm  ~/local/bin/
	ln -sf $(PWD)/bin/git-patdiff  ~/local/bin/

vimrc_repo?= git@github.com:proger/vimrc.git
deploy-vim:
	-cd ~; git clone $(vimrc_repo) .vim
	cd ~/.vim; git pull --rebase; $(MAKE)

USER?= proger
osx-fixtank:
	mount -uw /
	launchctl load /System/Library/LaunchDaemons/com.apple.opendirectoryd.plist
	dscl localonly -change /Local/Default/Users/$(USER) NFSHomeDirectory /Users/$(USER) /tank/$(USER)
	mv Users tank
	ln -s tank Users

.PHONY: all deploy deploy-vim osx-fixtank
