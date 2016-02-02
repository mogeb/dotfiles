#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias l='ls -lt'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rm='rm -I'

alias cp='cp -a'

alias cdb='cd $OLD_PWD'

export EDITOR=vim
export PS1="\[\033[01;32m\]\$(pwd)\[\033[01;34m\] $>\[\033[00m\] "

if [ $UID -eq 0 ] ; then
  export PS1="\[\033[01;31m\]# \$(pwd) $>\[\033[00m\] "
fi

#Automatically do an ls after each cd
cd() {
  OLD_PWD=`pwd`
  if [ -n "$1" ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
  fi
}

# lh: ls -lt | head -n 15
lh() {
	if [ -n "$1" ]; then
		ls -lt "$1" | head -n 15
	else
		ls -lt | head -n 15
	fi
}

YELLOW="\[\033[0;33m\]"
NO_COLOUR="\[\033[0m\]"
# Git configuration
if [ "\$(type -t __git_ps1)" ]; then
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWSTASHSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	PS1="$PS1\$(__git_ps1 '$YELLOW(git:%s$YELLOW)> $NO_COLOUR')"
fi

source ~/.git-completion.bash

if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f `which powerline-daemon` ]; then
	powerline-daemon -q
	POWERLINE_BASH_CONTINUATION=1
	POWERLINE_BASH_SELECT=1
	. /usr/share/powerline/bindings/bash/powerline.sh
fi
