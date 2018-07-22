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
end

# function enable_caps_lock
#   xmodmap -e "!clear Lock"
#   xmodmap -e "keycode 66 = Caps_Lock NoSymbol Caps_Lock"
# end

# function disable_caps_lock
#   xmodmap -e "clear Lock"
#   xmodmap -e "keycode 66 = Escape NoSymbol Escape"
# end

# export DISPLAY=:0
# # Map CapsLock -> Escape
# switch (uname)
#   case Linux
#     disable_caps_lock
# end


