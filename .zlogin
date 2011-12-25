stty status '^T' 2>/dev/null || true

export PATH=$HOME/local/bin:$HOME/.local/bin
export PATH=$PATH:$HOME/local/ruby/bin
export PATH=$PATH:$HOME/.cabal/bin

export PATH=$PATH:/Developer/Marmalade/5.1/s3e/bin

#export PATH=$PATH:$HOME/dev/llvm/Debug+Asserts/bin
#export PATH=$PATH:$HOME/local/mongo/bin

export PATH=$PATH:/usr/gcc/4.6/bin
export PATH=$PATH:/usr/postgres/9.0/bin
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
export PATH=$PATH:/usr/local/bin:/usr/local/sbin
export PATH=$PATH:/Developer/usr/bin
export PATH=$PATH:/usr/gnu/bin
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin

#export PATH=$PATH:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin
#export PATH=$PATH:/usr/local/lib/qt4/bin:/usr/local/jdk-1.7.0/bin

#export PATH=$PATH:/usr/X11R7/bin:/usr/pkg/bin:/usr/pkg/sbin
#export PATH=$PATH:/usr/pkg/qt4/bin:/usr/games

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/local/objc/lib
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/dev/llvm/Debug+Asserts/lib
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/dev/mongo
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/dev/mongo-c-driver

#export EDITOR=/usr/local/bin/vim
export PAGER=/usr/bin/less

export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/emacs
#export PAGER=/bin/less
export LESSCHARSET=utf-8

#export LANG=en_US.UTF-8
#unset LC_ALL
#unset LC_CTYPE
case $TERM in
#	*) export LC_CTYPE=uk_UA.KOI8-U;;
	*) export LC_CTYPE=en_US.UTF-8;;
esac

export TEXMFHOME=$HOME/.texmf
export OCAMLFIND_CONF=$HOME/.ocamlfind.conf
#export LUAPKG="/usr/pkg/lib/lua/5.1"
export GEM_HOME=$HOME/local/ruby

#export _PERL5LIB=$PERL5LIB
#export PERL5LIB=$PERL5LIB:~/local/perl/lib/perl5
#export PERL5LIB=$PERL5LIB:$HOME/local/perl/lib/perl5/site_perl/5.12.0
#export PERL5LIB=$PERL5LIB:$HOME/local/perl/lib/perl5/site_perl/5.12.0/x86_64-netbsd-thread-multi

export ERL_LIBS=$HOME/dev/erlzmq2/ebin
export PYTHONPATH=$HOME/.local/lib/python2.6/site-packages


export HISTFILE=$HOME/.zshistory
# for ksh
export ENV=$HOME/.kshrc

# perl -I$HOME/local/perl5/lib/perl5 -Mlocal::lib
export PERL_LOCAL_LIB_ROOT="/home/proger/local/perl5";
export PERL_MB_OPT="--install_base /home/proger/local/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/proger/local/perl5";
export PERL5LIB="/home/proger/local/perl5/lib/perl5/i86pc-solaris-64int:/home/proger/local/perl5/lib/perl5";
export PATH="/home/proger/local/perl5/bin:$PATH";
