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
    TARGET_FILE="$HOME/.$1"

    echo "Create sym link for $1, at $TARGET_FILE..."
    if [ -L "$TARGET_FILE" ]; then
        rm -f "${TARGET_FILE}"
    fi
    SRC="$PRGDIR/rc/$1"
    ln -s $SRC $TARGET_FILE
}

function setup_vim() {
    echo "Setup VIM..."
    # Clean VIM settings
    rm -rf ~/.vim
    rm -f ~/.vimrc ~/.gvimrc
    rm -f ~/.vimrc.local ~/.gvimrc.local ~/.vimrc.before ~/.vimrc.after

    # Install fisa vim config bundle
    curl -L -o ~/.vimrc https://raw.github.com/fisadev/fisa-vim-config/master/.vimrc

    #VIM_PS_LINENUMBER="`grep -n "Powerline_symbols" ~/.vimrc | cut -f1 -d:`"
    #if [ -n "$VIM_PS_LINENUMBER" ]; then
    #    echo "Find Powerline_symbols at $VIM_PS_LINENUMBER"
    #    echo "Enable power line symbols..."
    #    sed -i "${VIM_PS_LINENUMBER}s/\" //" ~/.vimrc
    #else
    #    echo "Powerline symbols not found."
    #fi

    CUSTOM_GITHUB_REPO_LINENUMBER="`grep -n "Bundles from GitHub repos:" ~/.vimrc | cut -f1 -d:`"
    if [ -n "$CUSTOM_GITHUB_REPO_LINENUMBER" ]; then
        echo "Find bundles from github repos at ${CUSTOM_GITHUB_REPO_LINENUMBER}"
        bundles="\" Bundles from GitHub repos: \n\n\" My custom bundles \nsource ~/.vimrc.bundles"
        sed -i "${CUSTOM_GITHUB_REPO_LINENUMBER}s/.*/${bundles}/" ~/.vimrc
    fi

    echo -e "\\nsource ~/.vimrc.local\\n" >> ~/.vimrc

    mkdir -p ~/.fonts
    if [ ! -e "$HOME/.fonts/Monaco_Linux-Powerline.ttf" ]; then
        ln -s $PRGDIR/Monaco_Linux-Powerline.ttf ~/.fonts/Monaco_Linux-Powerline.ttf
    fi
    sudo fc-cache -vf > /dev/null 2>&1

    create_link vimrc.bundles $HOME/.vimrc.bundles
    create_link vimrc.local   $HOME/.vimrc.local
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

    ENABLED_PLUGINS="git tmux"
    if [ `uname` == "Darwin" ]; then
        ENABLED_PLUGINS="${ENABLED_PLUGINS} autojump ruby vagrant docker osx brew brew-cask pip python fabric"
    fi

    PLUGINS_LINENUMBER="`grep -n "(git)" ~/.zshrc | cut -f1 -d:`"
    echo "Find plugins at $PLUGINS_LINENUMBER"
    if [ -n "$PLUGINS_LINENUMBER" ]; then
        sed -i "${PLUGINS_LINENUMBER}s/git/${ENABLED_PLUGINS}/" ~/.zshrc
    fi

    echo -e "
source ~/.zshrc.local
    " >> ~/.zshrc

    source ~/.zshrc

    echo "ZSH is ready to use now."
}

setupdir

echo "Working directory: $PRGDIR"

function create_links() {
    create_link bash_aliases .bash_aliases
    create_link bash_path .bash_path
    create_link bash_env .bash_env
    create_link gitconfig
    create_link zshrc.local .zshrc.local
    create_link tmux.conf .tmux.conf
}

# sudo apt-get install vim zsh tmux autojump
case "$1" in
    vim)
        setup_vim
    ;;
    zsh)
        setup_zsh
    ;;
    links)
        create_links
    ;;
    *)
        setup_zsh
        setup_vim
        create_links
    ;;
esac

