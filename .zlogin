stty status '^T' # bsd only

export ENV=/etc/profile


if [[ -o login ]]; then
	export PATH=$HOME/.local/bin:$HOME/local/ruby/bin
	export PATH=$PATH:$HOME/.cabal/bin

	export PATH=$PATH:/usr/local/share/npm/bin

	#export PATH=$PATH:/opt/local/bin:/opt/local/sbin
	export PATH=$PATH:/opt/ghc/bin
	export PATH=$PATH:/usr/local/bin:/usr/local/sbin
	export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin
	#export PATH=$PATH:/usr/texbin
	#export PATH=$PATH:/usr/pkg/bin:/usr/pkg/sbin
	export PATH=$PATH:$HOME/Library/Python/2.7/bin

	export NIX_PATH=$HOME/dev/nix:ssh-config-file=$HOME/.ssh/config
	export PATH=$HOME/.nix-profile/bin:$PATH
	export PATH=$HOME/local/bin:$PATH
fi

export EDITOR=vim

case $TERM in
	*) export LC_CTYPE=en_US.UTF-8;;
esac

export GEM_HOME=$HOME/local/ruby
export HISTFILE=$HOME/.zshistory

# for ksh
#export ENV=$HOME/.kshrc

export PYTHONPATH=$HOME/local/python:$HOME/Library/Python/2.7/lib/python/site-packages:$HOME/.local/lib/python2.7/site-packages
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home
export EC2_HOME=/usr/local/Cellar/ec2-api-tools/1.6.12.0/libexec

export AWS_CLOUDWATCH_HOME="/usr/local/Cellar/cloud-watch/1.0.20.0/libexec"
export SERVICE_HOME="$AWS_CLOUDWATCH_HOME"


export COPYFILE_DISABLE=true

