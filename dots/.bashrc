# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=
HISTFILESIZE=

shopt -s checkwinsize

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
        echo "\[$(tput setaf 1)\][\[$(tput setaf 2)\]${BRANCH}\[$(tput setaf 3)\]${STAT}\[$(tput setaf 1)\]]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#sqlite
alias sqlite='sqlite3'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$PATH:/home/housedhorse/.vim/bundle/vim-live-latex-preview/bin:/home/housedhorse/.local/bin"
export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
export PATH="$PATH:/home/housedhorse/.scripts"

# --My aliases--
# Aliases for makefile typos
alias aekm='make'
alias aemk='make'
alias akem='make'
alias akme='make'
alias amek='make'
alias amke='make'
alias eakm='make'
alias eamk='make'
alias ekam='make'
alias ekma='make'
alias emak='make'
alias emka='make'
alias kaem='make'
alias kame='make'
alias keam='make'
alias kema='make'
alias kmae='make'
alias kmea='make'
alias maek='make'
alias makee='make'
alias makke='make'
alias maake='make'
alias mmake='make'
alias meak='make'
alias meka='make'
alias mkae='make'
alias mkea='make'

# Alias for python3
alias python='python3'
alias pip='pip3'

# Aliases for vim
alias vim='nvim'
alias vi='vim'
alias v='vim'
alias vmi='vim'
alias mvi='vim'
alias ivm='vim'
alias imv='vim'
alias vimm='vim'
alias vii='vim'
alias vvi='vim'

alias fixnet='sudo /etc/init.d/network-manager restart'

alias cpu='top -b -n1 -c'

# disable ctrl s
stty -ixon

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# scrot for screenshots
alias scrot='scrot ~/pictures/screenshots/%m-%d_%H:%M:%S.png $ARGS'

# R convenience
alias r='R'
alias rscript='Rscript'

#mupdf
mupdf_() {
  mupdf "$1" > /dev/null 2> /dev/null&
}
alias mupdf='mupdf_'

# sudo stuff
alias sudo='sudo '

# change wallpaper
change-wallpaper() {
  rm ~/.wallpaper
  ln -s $(realpath "$1") ~/.wallpaper
}
alias cwp='change-wallpaper '

export EDITOR=nvim
export BROWER=firefox

# git completion
source ~/.scripts/git-completion.bash

# prompt and directory colors
#LS_COLORS=$LS_COLORS:'ln=1;34:di=1;36:fi=37:' ; export LS_COLORS
export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 4)\]\u\[$(tput setaf 4)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\w\[$(tput setaf 1)\]]\[$(tput setaf 2)\]\`parse_git_branch\`\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"

# default image viewer
alias feh="sxiv"

# auto virtual envs
source ~/.scripts/autovenv.sh

#save changed directory as last changed directory
function cd_
{
  cd "$@"
  echo $PWD > ~/.last_dir
}

alias cd='cd_'
