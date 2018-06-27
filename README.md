# Environment Setup

# Linux

Install fish:
```
wget https://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_9.0/amd64/fish_2.7.1-1_amd64.deb /tmp/fish.deb
sudo dpkg -i /tmp/fish.deb
```

Copy config files
```
mkdir -p ~/.config/fish/functions
cp fish_config.fish ~/.config/fish/config.fish
cp initial_fish.fish ~/.config/fish/initial_fish.fish
cp cd.fish ~/.config/fish/functions/cd.fish
chmod a+x ~/.config/fish/functions/cd.fish

# Install powerline fonts
git clone https://github.com/powerline/fonts.git /tmp/fonts
mkdir -p ~/.fonts
cp /tmp/fonts/SourceCodePro/Source\ Code\ Pro\ Black\ for\ Powerline.otf ~/.fonts/
fc-cache -vf ~/.fonts
```

On Fish Run (one time)
```
fish ~/.config/fish/initial_fish.fish
```


Install Neovim
```
sudo apt-get install python-pip python3-pip -y
sudo apt-get install neovim -y
pip2 install --user neovim
```




