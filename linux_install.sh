#!/bin/bash

# GIT
################################################################
sudo apt-get install git -y

# NEOVIM
################################################################
sudo apt-get install python-pip python3-pip -y
sudo apt-get install neovim -y
pip2 install --user neovim
pip3 install --user neovim

# TMUX
################################################################
sudo apt-get install tmux -y
ln -s `pwd`/tmux.conf ~/.tmux.conf
touch ~/.tmux.conf.local

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
echo "fish" >> ~/.bashrc.local
echo "source ~/.bashrc.local" > ~/.bashrc
echo "Make the terminal start fish"

echo "For custom terminal (Alacritty), run linux_terminal_install.sh"

