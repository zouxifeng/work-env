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
    TARGET_FILE=$1
    if [ -z "$2" ]; then
        DST=~
        TARGET_FILE=$2
    fi

    if [ -L "$DST/$FILE" ]; then
        rm -f "$DST/$FILE"
    fi
    ln -s $PRGDIR/rc/$FILE $DST/$TARGET_FILE
}

function setup_vim() {
    echo "Setup VIM..."
    # Clean VIM settings
    rm -rf ~/.vim ~/.vimrc ~/.gvimrc
    rm -f ~/.vimrc.local ~/.gvimrc.local ~/.vimrc.before ~/.vimrc.after

    # Install fisa vim config bundle
    curl -o ~/.vimrc https://raw.github.com/fisadev/fisa-vim-config/master/.vimrc

    VIM_PS_LINENUMBER="`grep -n "Powerline_symbols" ~/.vimrc | cut -f1 -d:`"
    echo "Find Powerline_symbols at $VIM_PS_LINENUMBER"
    if [ -n "$VIM_PS_LINENUMBER" ]; then
        echo "Enable power line symbols..."
        sed -i "${VIM_PS_LINENUMBER}s/\" //" ~/.vimrc
    fi

    echo -e "
\" My custom settings.\\n\
Bundle 'airblade/vim-gitgutter'\\n\
\" gz in command mode closes the current buffer\\n\
map gz :bdelete<cr>\\n" >> ~/.vimrc

    mkdir -p ~/.fonts
    ln -s $PRGDIR/Monaco_Linux-Powerline.ttf ~/.fonts
    sudo fc-cache -vf > /dev/null 2>&1

    echo "VIM is ready to use now."
}

function setup_zsh() {
    echo "Setup zsh..."
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    THEME_LINENUMBER="`grep -n "ZSH_THEME" ~/.zshrc | cut -f1 -d:`"
    echo "Find ZSH_THEME at $THEME_LINENUMBER"
    if [ -n "$THEME_LINENUMBER" ]; then
        sed -i "${THEME_LINENUMBER}s/robbyrussell/dpoggi/" ~/.zshrc
    fi

    PLUGINS_LINENUMBER="`grep -n "(git)" ~/.zshrc | cut -f1 -d:`"
    echo "Find plugins at $PLUGINS_LINENUMBER"
    if [ -n "$PLUGINS_LINENUMBER" ]; then
        sed -i "${PLUGINS_LINENUMBER}s/git/git tmux autojump/" ~/.zshrc
    fi


    echo -e "
source ~/.bash_env
source ~/.bash_aliases
source ~/.bash_path
    " >> ~/.zshrc

    source ~/.zshrc

    echo "ZSH is ready to use now."
}

setupdir

sudo apt-get install vim zsh tmux autojump

setup_zsh
# setup_vim

echo "Working directory: $PRGDIR"
create_link .bash_aliases
create_link .bash_path
create_link .bash_env
create_link .gitconfig
create_link .tmuxrc .tmux.conf


