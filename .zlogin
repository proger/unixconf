stty status '^T' # bsd only


if [[ -o login ]]; then
	export PATH=$HOME/local/bin:$HOME/.local/bin:$HOME/local/ruby/bin
	export PATH=$PATH:$HOME/.cabal/bin

	export PATH=$PATH:/usr/local/share/npm/bin

	export PATH=$PATH:/opt/local/bin:/opt/local/sbin
	export PATH=$PATH:/usr/local/bin:/usr/local/sbin
	export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin
	#export PATH=$PATH:/usr/texbin
	#export PATH=$PATH:/usr/pkg/bin:/usr/pkg/sbin

	## openbsd/netbsd/historical:
	#export PATH=$PATH:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin
	#export PATH=$PATH:/usr/local/lib/qt4/bin:/usr/local/jdk-1.7.0/bin
	#export PATH=$PATH:/usr/X11R7/bin:/usr/pkg/bin:/usr/pkg/sbin
	#export PATH=$PATH:/usr/pkg/qt4/bin:/usr/games
	#export PATH=$PATH:/Developer/Marmalade/5.1/s3e/bin
	#export PATH=$PATH:$HOME/dev/llvm/Debug+Asserts/bin
	#export PATH=$PATH:$HOME/local/mongo/bin
	#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/local/objc/lib
	#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/dev/llvm/Debug+Asserts/lib
	#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/dev/mongo
	#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/dev/mongo-c-driver

	if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then source $HOME/.nix-profile/etc/profile.d/nix.sh; fi
fi

export EDITOR=vim
#
#export LESSCHARSET=utf-8
#export LANG=en_US.UTF-8
#unset LC_ALL
#unset LC_CTYPE
case $TERM in
#	*) export LC_CTYPE=uk_UA.KOI8-U;;
	*) export LC_CTYPE=en_US.UTF-8;;
esac

#export TEXMFHOME=$HOME/.texmf
#export OCAMLFIND_CONF=$HOME/.ocamlfind.conf
#export LUAPKG="/usr/pkg/lib/lua/5.1"
export GEM_HOME=$HOME/local/ruby

#export _PERL5LIB=$PERL5LIB
#export PERL5LIB=$PERL5LIB:~/local/perl/lib/perl5:/tank/proger/local/perl/lib/perl5/site_perl/5.12.3/darwin-thread-multi-2level
export PERL5LIB=$PERL5LIB:~/local/perl/lib/perl5/site_perl
#export PERL5LIB=$PERL5LIB:$HOME/local/perl/lib/perl5/site_perl/5.12.0
#export PERL5LIB=$PERL5LIB:$HOME/local/perl/lib/perl5/site_perl/5.12.0/x86_64-netbsd-thread-multi

export HISTFILE=$HOME/.zshistory

# for ksh
#export ENV=$HOME/.kshrc

export PYTHONPATH=$HOME/local/python:$HOME/.local/lib/python2.7/site-packages
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages

# flex
#export PATH=/usr/local/Cellar/flex_sdk/4.6.0.23201/libexec/bin:$PATH
#export FLEX_HOME=/usr/local/Cellar/flex_sdk/4.6.0.23201/libexec
# mkdir -p ~/.ant/lib
# ln -s /usr/local/Cellar/flex_sdk/4.6.0.23201/libexec/ant/lib/flexTasks.jar

#export JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/1.6.0_33-b03-424.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7..k/Contents/Home
#export JAVA_VERSION=CurrentJDK

export HAXE_LIBRARY_PATH=/usr/local/share/haxe/std

export COPYFILE_DISABLE=true
#export JYTHON_HOME=/usr/local/Cellar/jython/2.5.2/libexec

