#!/bin/bash

# Install Alacritty
## Install dependencies
sudo apt-get install cmake libfreetype6-dev libfontconfig1-dev xclip

## Install Rust (follow instructions)
curl https://sh.rustup.rs -sSf | sh

## Compile
git clone https://github.com/jwilm/alacritty.git
cd alacritty
cargo build --release

## Install fish completions
sudo cp alacritty-completions.fish $__fish_datadir/vendor_completions.d/alacritty.fish

## Install config file
cd ..
mkdir -p ~/.config/alacritty
cp alacritty.yml ~/.config/alacritty # Copy... all machines are different

## Install powerline fonts
git clone https://github.com/powerline/fonts.git /tmp/fonts
mkdir -p ~/.fonts
cp /tmp/fonts/SourceCodePro/Source\ Code\ Pro\ Black\ for\ Powerline.otf ~/.fonts/
fc-cache -vf ~/.fonts
