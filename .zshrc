source ~/.unixconf/zsh/zshrc

case $(uname) in
	*BSD) suffix="bsd";;
	Linux) suffix="linux";;
	Darwin) suffix="osx";;
	SunOS) suffix="solaris";;
esac

source ~/.unixconf/zsh/zshrc.$suffix
