# Environment install for Windows

These are the instructions for setting my common development setup for Windows.

## General

- Go to windows setup, Sound, select default beep and map to "None".

## Windows Terminal

Install windows terminal
- Fonts (https://www.nerdfonts.com/font-downloads)
    - Agave Nerd Font works fine, but any will do.
- Copy the config json pointed here into the the config

## Clink

Clink is a very good batch enhancement.

- Install clink: https://chrisant996.github.io/clink/
    - Install the Flex prompt enhancement: https://github.com/chrisant996/clink-flex-prompt

Set this setting:
Make sure that we don't use Windows style completion (which sucks).
```
clink set clink.default_bindings bash
```

Correct completion highlighting.
```
clink set match.coloring_rules  di=93:ro ex=1;32:ex=1:ro=32:di *.tmp=90
```

## Core Utils

These are the gnu utilities (cp, ls) to be available.
We use a built made in Rust: https://github.com/uutils/coreutils/releases

For that we create a ton of little batch script that wrap over this binary:
Run coreutils script (in admin)
```
powershell -executionpolicy bypass .\setup_coreutils.ps1
```

Add to PATH
```
C:\cdc\bin
C:\cdc\bin\coreutils
```

## Neovim

### Dependencies

- Install latest python 3 (https://www.python.org/downloads/windows/)

Install Neovim-python hook:
```
python -m pip  install --user pynvim
```

- Install 7zip
    - Required by Mason
    - Add to PATH
- Install Go: https://go.dev/doc/install
- Install pwsh (Cross platform powershell): https://github.com/PowerShell/PowerShell
- Install riprep: https://github.com/BurntSushi/ripgrep
- Install fd: https://github.com/sharkdp/fd
- Install Everything: https://www.voidtools.com/
- Install Chocolatey: https://chocolatey.org/install#individual
- Install Bazelisk:
on Administrator run
```
choco install bazelisk
```

- Install Msys2 (Follow https://bazel.build/install/windows)
    - Install the pacman dependencies
    - add BAZEL_SH env to the path of the installed bash.exe

- Install clang: https://github.com/llvm/llvm-project/releases/
- Install stylua: https://github.com/JohnnyMorganz/StyLua

### The editor

- Install neovim (https://neovim.io/)
- Make a juntion this config into the place where Neovim expects:
```
mklink /J C:\Users\<user>\AppData\Local\nvim <Full Path to Repo>\nvim
```

Once installed open the editor a few times and the installation of the things should work.
If there is an error, update this list with the fix.

TODO: Fuzzy sorter native (https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions)

