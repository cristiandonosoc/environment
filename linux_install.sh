#!/bin/bash
# 2018 Cristián Donoso.
# This software is distributed as Public Domain.
# Feel free to use it whoever you like.

# Install several environment utils I use
# Normally I run the commands manually. Takes about 5 minutes.
# I don't this that often: https://xkcd.com/1205/

# NOTE: I like to keep my setup to be always up to date as I tweak something on
#       some machine. For this, all the config files are linked to the correct
#       location, so that all changes are reflected in the repo.
#       If there is a very local thing, for every config I create a .local
#       variant that's sourced from the tracked one.

## TMUX
## -----------------------------------------------------------------------------
# If you don't use tmux (or screen... no flame war), YOU SHOULD!
# It's a "server" that holds the terminals for you, instead of the session.
# This enables you to detach from tmux and the terminal is still there.
# Lose SSH connection... No problem! The session is still attached to tmux.
# Just reconnect and continue!
sudo apt-get install tmux -y
ln -s `pwd`/tmux.conf ~/.tmux.conf
touch ~/.tmux.conf.local

## INSTALL NEOVIM
## -----------------------------------------------------------------------------
## Neovim is a rewrite of vim that maintains the exact API but it's faster and
## has some goodies as a internal terminal and easier python integration (no
## required re-compilation).

# Install pip, for python 2 & 3. It's needed for the neovim-python integration.
sudo apt-get install python-pip python3-pip -y
sudo apt-get install neovim -y
pip2 install --user neovim  # neovim python2 integration.
pip3 install --user neovim  # neovim python3 integration.

# Needed for neovim to load vimrc from the normal locations.
mkdir -p ~/.config/nvim
ln -s $PWD/nvim.init.vim ~/.config/nvim/init.vim

## VIMRC
## -----------------------------------------------------------------------------
# Util files locations that the vimrc uses. Normally vim creates utility files,
# like *.swp which works as somekind of backup. By default vim creates it in the
# same location of the file, which it's annoying. My vimrc sends all of them to
# these locations.
mkdir -p ~/.vim/cache/swap
mkdir -p ~/.vim/cache/backup
mkdir -p ~/.vim/cache/undo

# Install the vimrc. The vimrc is heavily commented and it's worth going over
# one time to learn what some configs do.
ln -s `pwd`/vimrc ~/.vimrc
touch ~/.vimrc.local  # Local variant.

# Special functions I use. Mostly YouCompleteMe bindings.
ln -s $PWD/vimrc_extras.vim ~/.vim/vimrc_extras.vim
# I use clang-format from this python script.
ln -s $PWD/clang-format.py ~/.vim/clang-format.py

# Download Vundle. This is a package manager for vim.
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# This files are the plugins I normally use. There are not many.
ln -s ${PWD}/vundle_plugins.vim  ~/.vim/vundle_plugins.vim
touch ~/.vim/vundle_plugins.vim.local

# This is a reminder to myself.
# To install YouCompleteMe, go to the YCM run:
# python ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
# This is if you want C++ completer (which you want!). Use --help for all the
# options.
echo "Run :VundleInstall from vim. Install YouCompleteMe manually."

## FISH
## -----------------------------------------------------------------------------
# Fish is another kind of shell that holds some very nice properties and some
# VERY ANNOYING ones , mainly that they decided to break bash compatibilities.
# THEY DON'T SUPPORT &&!!!!!
# This means you will get all kind of annoyances, specially with environment
# variables and ways to do scripting.
# Overall I got used to it and use fish everyday, but I wish they weren't so
# asshole about it. They have a pillar of "user centric", but they decided to
# screw everyone by making themselved special. Just sad, really.
#
# IMPORTANT: The prompt I use requires some special fonts to look good. I
#            install them in the Alacritty step. Either install the font or
#            don't use bob-the-fish (the prompt plugin).
sudo apt-get install fish -y

# Install fisher, which is a package manager for fish.
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

# Install the config.fish
# Fish has a directory for functions you can install. Lately I've resolved to
# put the functions in the config.fish
mkdir -p ~/.config/fish/functions
ln -s `pwd`/config.fish ~/.config/fish/config.fish
touch ~/.config/fish/config.fish.local

# Install extra functions
cp `pwd`/fish_functions/* ~/.config/fish/functions

# Install the plugins
cp fish.plugins ~/.config/fish
fish -c "install_plugins ~/.config/fish/fish.plugins"

# I still start bash and them immediatelly run fish. This sometimes enables me
# to set up some state from bash.
if Prompt "Have bash go directly to fish?"; then
  echo "source ~/.bashrc.local" > ~/.bashrc
  echo "fish; exit" >> ~/.bashrc.local
fi

# Link the config to home, instead of having to hunt them down.
ln -s ~/.config/fish/config.fish ~/.config.fish
ln -s ~/.config/fish/config.fish.local ~/.config.fish.local

## FZY
## -----------------------------------------------------------------------------
# Fuzzy search of files for fish. I don't really use this to be honest.
git clone https://github.com/jhawthorn/fzy /tmp/fzy
cd /tmp/fzy
make
sudo make install
cd -

## ALLACRITTY
## -----------------------------------------------------------------------------
# This is GPU-powered shell, that's very clean and responsive.
# It just feels right in linux. In OSX I use iterm2 and works fine. In windows
# I haven't been able to install it yet so I'm stuck with their crappy terminal.
# Overall, I like it, but it's not that important to have.

# Install dependencies
sudo apt-get install cmake libfreetype6-dev libfontconfig1-dev xclip
## Install Rust (follow instructions).
curl https://sh.rustup.rs -sSf | sh
## Compile.
git clone https://github.com/jwilm/alacritty.git /tmp/alacritty
cd /tmp/alacritty
cargo build --release
## Install fish completions (within fish)
sudo cp alacritty-completions.fish $__fish_datadir/vendor_completions.d/alacritty.fish
cd -  # Back to where we were.
## Install config file.
mkdir -p ~/.config/alacritty
cp alacritty.yml ~/.config/alacritty # Copy... all machines are different.

# Install powerline fonts.
# These are the fonts used by fish. Each OS installs them differently, but
# linux is the hardest, so I've scripted it.
git clone https://github.com/powerline/fonts.git /tmp/fonts
mkdir -p ~/.fonts
cp /tmp/fonts/SourceCodePro/*.otf ~/.fonts/
fc-cache -vf ~/.fonts

## EXTRAS
## -----------------------------------------------------------------------------
# Extra utilities I find very useful day to day.
# Ripgrep, replaces grep. It's much faster, but it's not that game-changer if
# you don't grep HUGE codebases. In that cases, it really shines.
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
sudo dpkg -i ripgrep_0.9.0_amd64.deb

# fd
# A human usable find. I've NEVER been able to remember find usage, but I never
# fail to use fd:
# fd <PATTERN> [LOCATIONS]
# no --name crap
wget https://github.com/sharkdp/fd/releases/download/v7.1.0/fd_7.1.0_amd64.deb
sudo dpkg -i fd_7.1.0_amd64.deb
