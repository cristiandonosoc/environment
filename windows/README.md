# Environment install for Windows

These are the instructions for setting my common development setup for Windows.

## General

- Go to windows setup, Sound, select default beep and map to "None".

# Fork

- Install git for windows, with "git credentials manager".
  - Make sure that you login with your github credentials.
- clone https://github.com/cristiandonosoc/environment

## Windows Terminal Config

- For windows terminal, replace the keys in windows_terminal_config.json into the terminal config.
- Install a nice font from https://www.nerdfonts.com/font-downloads
	- Meslo Nerd Font is nice
	- Install it and then configure Windows terminal to use it.

### Clink

Clink is a very good batch enhancement.

- Install enhanced clink from https://github.com/chrisant996/clink
- Install https://github.com/chrisant996/clink-flex-prompt
- Set it to bash mode: `clink set clink.default_bindings bash`

Enjoy!

## Neovim setup

- Install neovim: https://github.com/neovim/neovim/wiki/Installing-Neovim
- Run windows\setup_vim.ps1
	- Remember the execution bypass for powershell scripts.
	- TODO(cdc): You might need to re-run the script because pip might not be loaded
	             into PATH since it's been installed in the same environment.
- Within nvim, run "PlugInstall"
- Add "C:\cdc\bin" and "C:\cdc\bin\coreutils" to PATH (via dialog).

### YouCompleteMe

YouCompleteMe needs to be compiled before it can work.
TODO(cdc): Automate this

1. Install CMake:

```
winget install -e --id Kitware.CMake
```

2. Install Go
3. Install Rust
4. Compile YouCompleteMe
```
cd %USERPROFILE%\.nvim\plugged\YouCompleteMe
```

### Rust(-analyzer)

Download the latest Rust-analyzer from https://github.com/rust-lang/rust-analyzer and put in
C:\cdc\bin

That will enable LspConfig

## Extras

- Install [Ripgrep](https://github.com/BurntSushi/ripgrep), put it in C:\cdc\bin
- Install [Black](https://github.com/psf/black) (A Python formatter):
```
pip install --user black
```

