#!/bin/bash

#find out the absolute path of the script
setupdir () {
  PRG="$0"

  while [ -h "$PRG" ]; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
      PRG="$link"
    else
      PRG=`dirname "$PRG"`/"$link"
    fi
  done

  # Get standard environment variables
  PRGDIR=`dirname "$PRG"`

  #Absolute path
  PRGDIR=`cd "$PRGDIR" ; pwd -P`
  SCRIPT_DIR="$PRGDIR"
}

function create_link() {
    FILE=$1
    DST=$2
    if [ -z "$2" ]; then
        DST=~
    fi

    if [ -L "$DST/$FILE" ]; then
        rm -f "$DST/$FILE"
    fi
    ln -s $PRGDIR/$FILE $DST/$FILE
}

setupdir

echo "Working directory: $PRGDIR"
create_link .bashrc
create_link .bash_aliases
create_link .bash_path
create_link .bash_env
create_link .profile
create_link .gitconfig
create_link .tmuxrc ~/.tmux.conf

# Clean VIM settings
rm -rf ~/.vim ~/.vimrc ~/.gvimrc
rm -f ~/.vimrc.local ~/.gvimrc.local ~/.vimrc.before ~/.vimrc.after

# Install fisa vim config bundle
curl -o ~/.vimrc https://raw.github.com/fisadev/fisa-vim-config/master/.vimrc
create_link .vimrc.after
echo "source .vimrc.after" >> ~/.vimrc

