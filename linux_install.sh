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
##            - neovim: Cool update to vim
##            - vimrc: My vimrc bindings/plugins/etc.
##            - tmux: Don't ever work without it.
##            - fish: Cool shell. Could be better tho.
##            - fzy: Nice fzy shell. Don't use it much.
##            - alacritty: GPU powered terminal.

# FUNCTION DEFINITIONS
################################################################################

function Prompt() {
  read -p "Install ${@}? [Y/n]: " response

  if [[ "${response}" =~ ^(yes|y| ) ]] || [[ -z "${response}" ]]; then
    return 0
  fi
  return 1
}

function DisplayHelp() {
  sed -n -e 's/^## //p' -e 's/^##$//p' < "${0}"
}

function InstallNeovim() {
  sudo apt-get install python-pip python3-pip -y
  sudo apt-get install neovim -y
  pip2 install --user neovim
  pip3 install --user neovim

  if Prompt "Also install Vimrc?"; then
    InstallVimrc
  fi
}

function InstallVimrc() {
  # Install the vimrc
  ln -s `pwd`/vimrc ~/.vimrc
  touch ~/.vimrc.local

  # Install swap dirs
  mkdir -p ~/.vim/cache/swap
  mkdir -p ~/.vim/cache/backup
  mkdir -p ~/.vim/cache/undo

  ln -s $PWD/vimrc_extras.vim ~/.vim/vimrc_extras.vim
  ln -s $PWD/clang-format.py ~/.vim/clang-format.py

  # Download Vundle
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

  ln -s ${PWD}/vundle_plugins.vim  ~/.vim/vundle_plugins.vim
  touch ~/.vim/vundle_plugins.vim.local

  echo "Run :VundleInstall from vim and remember to install YouCompleteMe manually."
}

function InstallTmux() {
  sudo apt-get install tmux -y
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
  sudo apt-get install fish -y

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
    echo "source ~/.bashrc.local" > ~/.bashrc
    echo "fish; exit" >> ~/.bashrc.local
  fi
}

function InstallAlacritty() {
  # Install Alacritty
  ## Install dependencies
  sudo apt-get install cmake libfreetype6-dev libfontconfig1-dev xclip

  ## Install Rust (follow instructions)
  curl https://sh.rustup.rs -sSf | sh

  ## Compile
  git clone https://github.com/jwilm/alacritty.git /tmp/alacritty
  cd /tmp/alacritty
  cargo build --release

  ## Install fish completions
  sudo cp alacritty-completions.fish ${__fish_datadir}/vendor_completions.d/alacritty.fish

  cd -

  ## Install config file
  mkdir -p ~/.config/alacritty
  cp alacritty.yml ~/.config/alacritty # Copy... all machines are different

  ## Install powerline fonts
  git clone https://github.com/powerline/fonts.git /tmp/fonts
  mkdir -p ~/.fonts
  cp /tmp/fonts/SourceCodePro/Source\ Code\ Pro\ Black\ for\ Powerline.otf ~/.fonts/
  fc-cache -vf ~/.fonts
}

function InstallAll() {
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
while [[ "${1}" =~ ^- ]]; do
  case "${1}" in
    -h|--help)
      DisplayHelp
      exit 0
      ;;
    neovim)
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


