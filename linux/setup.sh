sudo apt-get install -y gh
gh auth login

## -----------------------------------------------------------------------------
# If you don't use tmux (or screen... no flame war), YOU SHOULD!
# It's a "server" that holds the terminals for you, instead of the session.
# This enables you to detach from tmux and the terminal is still there.
# Lose SSH connection... No problem! The session is still attached to tmux.
# Just reconnect and continue!

sudo apt-get install -y tmux
ln -s $PWD/tmux.conf ~/.tmux.conf
touch ~/.tmux.conf.local

## INSTALL NEOVIM
## -----------------------------------------------------------------------------
## Neovim is a rewrite of vim that maintains the exact API but it's faster and
## has some goodies as a internal terminal and easier python integration (no
## required re-compilation).

# TODO(cdc): Detect if python3 is installed.

sudo apt-get install -y python3-pip
sudo apt-get install -y neovim
python3 -m pip install --user pynvim

# Needed for neovim to load vimrc from the normal locations.
mkdir -p ~/.config/nvim
ln -s $PWD/init.vim ~/.config/nvim/init.vim

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
ln -s $PWD/../vimrc ~/.vimrc
touch ~/.vimrc.local  # Local variant.

# Special functions I use. Mostly YouCompleteMe bindings.
ln -s $PWD/vimrc_extras.vim ~/.vim/vimrc_extras.vim

# Install plug, a plugin manager.
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# This is a reminder to myself.
# To install YouCompleteMe, go to the YCM run:
# python ~/.vim/bundle/YouCompleteMe/install.py --clang-completer
# This is if you want C++ completer (which you want!). Use --help for all the
# options.
echo "Run :VundleInstall from vim. Install YouCompleteMe manually."

## YCM
## -------------------------------------------------------------------------------------------------

# Install Go (Update version accordingly).
rm -rf /usr/local/go
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
rm https://go.dev/dl/go1.21.0.linux-amd64.tar.gz

#add to ~/.profile
PATH=/usr/local/go/bin:$PATH

sudo apt-get install -y cmake

~/.nvim/plugged/YouCompleteMe/install.py --clang-completer --go-completer

## UTILITIES
## -------------------------------------------------------------------------------------------------

sudo apt-get install -y ripgrep
sudo apt-get install -y fd-find

## STARSHIP
## -----------------------------------------------------------------------------
#
# Starship is a cross-platform prompt written in rust.

curl -sS https://starship.rs/install.sh | sh
