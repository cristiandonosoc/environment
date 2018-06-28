# Paths
set PATH ~/Local/bin $PATH

# aliases
alias ll "ls -lha"
alias grep "grep --color"
alias vim "nvim"

set -g EDITOR nvim

# Bob-the-fish
set -g theme_newline_cursor yes
set -g theme_display_git yes
set -g theme_show_exit_status yes
set -g fish_prompt_pwd_dir_length 0

# Source rust
if test -e ~/.cargo/env
  source ~/.cargo/env
end

# Source local
if test -e ~/.config/fish/config.fish.local
  source ~/.config/fish/config.fish.local
end
