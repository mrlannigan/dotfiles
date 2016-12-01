#!/bin/bash

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lsa='ls -alh'

alias editalias='vim ~/.bash_aliases; source ~/.bash_aliases'
alias edithosts='sudo vim /etc/hosts'

alias tmp='\cd /tmp'

#NET
alias lsports='lsof -iTCP -sTCP:LISTEN -n -P'

#GIT
alias gst='\git status'
alias gc='\git commit'
alias gca='\git commit -am'
alias ga='\git add -v'
alias geffort='\git effort --above'
alias glog='\git log --oneline --color-words'

#SVN
alias sinfo='\svn info'
alias si='sinfo'
alias sci='\svn commit -m '
alias st='sinfo; \svn status'
alias sst='sinfo; \svn status -u'
alias sswtrunk="\svn switch '^/trunk' ."
alias ssw="~/.config/tools/svnSwitch.sh "
alias sswbranch="~/.config/tools/svnSwitchToBranch.sh "
alias sup='\svn up'
alias stcmp='\svn diff `\svn info | grep "URL" | cut -d " " -f 2` ^/trunk --summarize'
alias stags="\svn ls ^/tags -v | awk '{ print \$1,\$6 }' | sort -n | grep -v '\./$' | awk '{ print \$2 }'"

alias goto='~/.config/tools/goto.sh '

#COLORED MANUAL PAGES
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

#AUTO COMPLETE
function _clientdirs()
{
	local curw
	COMPREPLY=()
	curw=${COMP_WORDS[COMP_CWORD]}
	if [ "$CACHEDOUTPUT" = '' ]; then
		if [ ! -f ${HOME}/.cache_dev_folders ]; then
			CACHEDOUTPUT=$(find ${HOME}/dev -maxdepth 2 ! -type f -exec ls -d -1 "{}" \; | cut -sd / -f 5- | grep -vE ".git|.idea")
			echo $CACHEDOUTPUT > ${HOME}/.cache_dev_folders
		else
			CACHEDOUTPUT=$(cat ${HOME}/.cache_dev_folders)
		fi
	fi
	COMPREPLY=($(compgen -W '${CACHEDOUTPUT}' -- $curw))
	return 0
}

function g()
{
	cd ~/dev/$1
}

complete -F _clientdirs g
