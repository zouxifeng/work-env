if [ 'Darwin' = "`uname`" ]; then
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
else
    alias ls="ls --color=auto"
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias dir='ls --format=vertical'
alias l.='ls -a'
alias rm='rm -i'
alias screen='screen -U'
alias lla="ls -la"
alias vi="vim"

# Git command aliases
alias gpu='git push'
alias gbr='git branch'
alias gco='git checkout'
alias gm='git commit'
alias gma='git commit -a'
alias gd='git diff'
alias gs='git status'
alias gra='git remote add'
alias grr='git remote rm'
alias grst='git reset'
alias gpl='git pull'
alias gl='git log'
alias ga='git add'
alias gcl='git clone'
alias gsvn='git svn'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias grep='grep --color=auto'
