#!/bin/bash

# NEOVIM
################################################################
sudo apt-get install python-pip python3-pip -y
sudo apt-get install neovim -y
pip2 install --user neovim
pip3 install --user neovim

# Install the vimrc
# TODO(cristiandonosoc): Vim plugins
ln -s `pwd`/vimrc ~/.vimrc
touch ~/.vimrc.local

# TMUX
################################################################
sudo apt-get install tmux -y
ln -s `pwd`/tmux.conf ~/.tmux.conf
touch ~/.tmux.conf.local

# FZY
################################################################

git clone https://github.com/jhawthorn/fzy /tmp/fzy
cd /tmp/fzy
make
sudo make install
cd -

# TODO(cristiandonosoc): Install vim bindings

# FISH
################################################################
# Install fish
sudo apt-get install fish

# Install fisherman
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

# Have bash open fish
# Better to open fish directly from the terminal
echo "fish && exit" >> ~/.bashrc.local
echo "source ~/.bashrc.local" > ~/.bashrc
echo "Make the terminal start fish"

# XCAPE
# This is for mapping an alone shift press to escape
################################################################

sudo apt-get install git gcc make pkg-config libx11-dev libxtst-dev libxi-dev
git clone https://github.com/alols/xcape.git /tmp/xcape
cd /tmp/xcape
make
sudo make install


echo "For custom terminal (Alacritty), run linux_terminal_install.sh"

