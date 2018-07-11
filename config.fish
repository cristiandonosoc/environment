# Paths
set PATH ~/Local/bin $PATH

# aliases
alias ll "ls -lha"
alias grep "grep --color"
alias vim "nvim"

set -g EDITOR nvim

# Bob-the-fish
set -g theme_newline_cursor yes             # 2 lines prompt
set -g theme_display_git yes                # Display git status
set -g theme_display_git_master_branch yes  # Display "master" name in git display
set -g theme_show_exit_status yes           # Show status code of last command
set -g theme_display_git_dirty_verbose yes  # Amount

# Prompt doesn't abbreviate paths
set -g fish_prompt_pwd_dir_length 0

# Source rust
if test -e ~/.cargo/env
  source ~/.cargo/env
end

# Source local config
if test -e ~/.config/fish/config.fish.local
  source ~/.config/fish/config.fish.local
en

# Map CapsLock -> Escape
switch (uname)
  case Linux
    export DISPLAY=:0
    # Remove Caps Lock functionality
    xmodmap -e "remove Lock = Caps_Lock"
    xmodmap -e "clear Lock"
    # Map CapsLock -> Escape
    xmodmap -e "keycode 66 = Escape NoSymbol Escape"
