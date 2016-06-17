#!/usr/bin/env make -f -

FILES= \
	.bashrc \
	.cvsignore \
	.gitconfig \
	.latexmkrc \
	.tmux.conf

all: deploy deploy-vim

deploy:
	$(foreach file,$(FILES),ln -sf $(PWD)/$(file) ~/;)
	#
	install -d ~/local/bin
	ln -sf $(PWD)/bin/tm  ~/local/bin/

vimrc_repo?= git@github.com:proger/vimrc.git
deploy-vim:
	-cd ~; git clone $(vimrc_repo) .vim
	cd ~/.vim; git pull --rebase; $(MAKE)

.PHONY: all deploy deploy-vim
