# Environment install for Windows

These are the instructions for setting my common development setup for Windows.

## General

1. Go to windows setup, Sound, select default beep and map to "None".

# Fork

1. Install git for windows, with "git credentials manager".
  - Make sure that you login with your github credentials.
2. clone https://github.com/cristiandonosoc/environment

## Windows Terminal Config

1. For windows terminal, replace the keys in windows_terminal_config.json into the terminal config.
2. Install enhanced clink from https://github.com/chrisant996/clink
3. Install a nice font from https://www.nerdfonts.com/font-downloads
   - Meslo Nerd Font is nice
	 - Install it and then configure Windows terminal to use it.
4. Install https://github.com/chrisant996/clink-flex-prompt

Enjoy!

## Neovim setup

1. Install neovim: https://github.com/neovim/neovim/wiki/Installing-Neovim
2. Run windows\setup_vim.ps1
	- Remember the execution bypass for powershell scripts.
	- TODO(cdc): You might need to re-run the script because pip might not be loaded
	             into PATH since it's been installed in the same environment.
3. Within nvim, run "PlugInstall"
4. Add "C:\cdc\bin" and "C:\cdc\bin\coreutils" to PATH (via dialog).

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

## Rust(-analyzer)

Download the latest Rust-analyzer from https://github.com/rust-lang/rust-analyzer and put in
C:\cdc\bin

That will enable LspConfig
