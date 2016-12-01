#!/bin/bash

[ -z "$PS1" ] && return

if [ -f ~/.bash_colors ]; then
    . ~/.bash_colors
fi

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=
export HISTFILESIZE=
export HISTFILE=~/.bash_eternal_history


PROMPT_COMMAND="RET=\$?; history -a; $PROMPT_COMMAND"

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM=true
GIT_PS1_SHOWCOLORHINTS=true

if [ ! -f ~/.git-completion.sh ]; then
  echo 'Downloading git completion script...'
  curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-completion.sh && chmod +x .git-completion.sh
  echo
fi

if [ ! -f ~/.git-prompt.sh ]; then
  echo 'Downloading git prompt script...'
  curl -s https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh && chmod +x .git-prompt.sh
  echo
fi

if [ -f ~/.git-completion.sh ]; then
  . ~/.git-completion.sh
fi

if [ -f ~/.git-prompt.sh ]; then
  . ~/.git-prompt.sh
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

function _returnLambda {
   if [[ $RET = 0 ]]; then echo -e '\033[01;32m'; else echo -e '\033[01;31m'; fi;
}

function __svn_branch {
   if [ -d .svn ]; then
       _branchName=`svn info | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$'`
       if [ -n $_branchName ]; then
           echo -ne `printf $1 ' ' $_branchName`
       fi
   fi
}

PS1='\[\033[01;32m\]  \[$(_returnLambda)\]λ \[\033[01;34m\]\W$(__svn_branch "\[\e[32m\]%s[%s]")$(__git_ps1 \ \[\e[32m\][%s]) \[\e[1;37m\]\$\[\033[00m\] '

export PATH=/usr/local/git/bin:${PATH}

export OCI_HOME=/opt/instantclient_11_2
export OCI_LIB_DIR=$OCI_HOME
export OCI_INCLUDE_DIR=$OCI_HOME/sdk/include
export OCI_INC_DIR=$OCI_HOME/sdk/include
export OCI_VERSION=11
export NLS_LANG=AMERICAN_AMERICA.UTF8
export DYLD_LIBRARY_PATH=$OCI_LIB_DIR

export DEVELOPER=lanniganj

export EDITOR=vim

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

eval "$(thefuck-alias)"

#
# NODE-COMPLETE
# Custom command line tab completion for Node.js
#
shopt -s progcomp
for f in $(command ls ~/.node-completion); do
  f="$HOME/.node-completion/$f"
  test -f "$f" && . "$f"
done

export NVM_DIR="/Users/julian/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

fortune | cowsay -f small
