#!/bin/bash
# 2018 Cristián Donoso.
# This software is distributed as Public Domain.
# Feel free to use it whoever you like.

### Install several environment utils I use
### NOTE: Adding a new functions must be added to the help, the switch and the
###       InstallAll function.

## Usage: ./linux_install.sh [--help/-h] [ELEMENTS ...]
##
##  ELEMENTS  List of elements to install. If not defined, all of them will be
##            installed. The elements come can be from the following list:
##            - brew: The apt of mac.
##            - neovim: Cool update to vim
##            - vimrc: My vimrc bindings/plugins/etc.
##            - tmux: Don't ever work without it.
##            - fish: Cool shell. Could be better tho.
##            - fzy: Nice fzy shell. Don't use it much.

# FUNCTION DEFINITIONS
################################################################################

function Prompt() {
  read -p "Install ${@}? [Y/n]: " response

  if [[ "${response}" =~ ^(Y|y|yes| ) ]] || [[ -z "${response}" ]]; then
    return 0
  fi
  return 1
}

function DisplayHelp() {
  sed -n -e 's/^## //p' -e 's/^##$//p' < "${0}"
}

function InstallBrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # Homebrew people are fucking morons
  sudo chown -R $(whoami) $(brew --prefix)/*
}

function InstallNeovim() {
  # Install pip
  brew install python
  brew install python3
  pip2 install --user --upgrade neovim
  pip3 install --user --upgrade neovim

  brew install neovim/neovim/neovim
  brew link neovim

  mkdir -p ~/.config/nvim
  ln -s ${PWD}/nvim.init.vim ~/.config/nvim/init.vim

  if Prompt "Also install Vimrc?"; then
    InstallVimrc
  fi
}

function InstallVimrc() {
  # Install the vimrc
  # TODO(cristiandonosoc): Vim plugins
  # TODO(cristiandonosoc): Install vim bindings
  ln -s `pwd`/vimrc ~/.vimrc
  touch ~/.vimrc.local

  # Install swap dirs
  mkdir -p ~/.vim/cache/swap
  mkdir -p ~/.vim/cache/backup
  mkdir -p ~/.vim/cache/undo

  # Download Vundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  ln -s ${PWD}/vundle_plugins.vim  ~/.vim/vundle_plugins.vim
  touch ~/.vim/vundle_plugins.vim.local

  echo "Run :VundleInstall from vim and remember to install YouCompleteMe manually."
}

function InstallTmux() {
  brew install --user --upgrade tmux
  ln -s `pwd`/tmux.conf ~/.tmux.conf
  touch ~/.tmux.conf.local
}

function InstallFzy() {
  git clone https://github.com/jhawthorn/fzy /tmp/fzy
  cd /tmp/fzy
  make
  sudo make install
  cd -
}

InstallFish() {
  brew install --user fish

  curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

  # Install the config.fish
  mkdir -p ~/.config/fish/functions
  ln -s `pwd`/config.fish ~/.config/fish/config.fish
  touch ~/.config/fish/config.fish.local

  # Install extra functions
  cp `pwd`/fish_functions/* ~/.config/fish/functions

  # Install the plugins
  cp fish.plugins ~/.config/fish
  fish -c "install_plugins ~/.config/fish/fish.plugins"

  if Prompt "Have bash go directly to fish?"; then
  n  echo "source ~/.bashrc.local" > ~/.bashrc
    echo "fish; exit" >> ~/.bashrc.local
  fi
}

unction InstallAll() {
  if Prompt "Brew"; then InstallBrew; fi
  if Prompt "Neovim"; then InstallNeovim; fi
  if Prompt "Vimrc"; then InstallVimrc; fi
  if Prompt "Tmux"; then InstallTmux; fi
  if Prompt "Fish"; then InstallFish; fi
  if Prompt "Fzy"; then InstallFzy; fi
}

# INPUT PARSING
################################################################################

if [[ -z "${1}" ]]; then
  echo "No input provided. Installing everything."
  InstallAll
  exit 0
fi

# Parse the input
while [[ -n "${1}" ]]; do
  case "${1}" in
    -h|--help)
      DisplayHelp
      exit 0
      ;;
    brew)
      InstallBrew
      shift
      ;;
    neovim)
      echo "NEOVIM"
      InstallNeovim
      shift
      ;;
    vimrc)
      InstallVimrc
      shift
      ;;
    tmux)
      InstallTmux
      shift
      ;;
    fish)
      InstallFish
      shift
      ;;
    fzy)
      InstallFzy
      shift
      ;;
    alacritty)
      InstallAlacritty
      shift
      ;;
    *)
      echo -r "Unknown option ${1}. Ignoring."
  esac
done


