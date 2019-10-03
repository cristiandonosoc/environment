# Paths
set PATH ~/Local/bin $PATH
set PATH ~/.cargo/bin $PATH

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


# My own cd
function __original_cd --description 'Change directory'
    set -l MAX_DIR_HIST 25

    if test (count $argv) -gt 1
        printf "%s\n" (_ "Too many args for cd command")
        return 1
    end

    # Skip history in subshells.
    if status --is-command-substitution
        builtin cd $argv
        return $status
    end

    # Avoid set completions.
    set -l previous $PWD

    if test "$argv" = "-"
        if test "$__fish_cd_direction" = "next"
            nextd
        else
            prevd
        end
        return $status
    end

    builtin cd $argv
    set -l cd_status $status

    if test $cd_status -eq 0 -a "$PWD" != "$previous"
        set -q dirprev
        or set -l dirprev
        set -q dirprev[$MAX_DIR_HIST]
        and set -e dirprev[1]
        set -g dirprev $dirprev $previous
        set -e dirnext
        set -g __fish_cd_direction prev
    end

    return $cd_status
end

function cd
  __original_cd $argv
  ls
end

switch (uname)
  case Linux
    function enable_caps_lock
      xmodmap -e "!clear Lock"
      xmodmap -e "keycode 66 = Caps_Lock NoSymbol Caps_Lock"
    end

    function disable_caps_lock
      xmodmap -e "clear Lock"
      xmodmap -e "keycode 66 = Escape NoSymbol Escape"
    end
end

# Fuchsia

function update
  builtin cd $FUCHSIA_DIR/zircon
  git checkout JIRI_HEAD 2> /dev/null
  builtin cd $FUCHSIA_DIR/garnet
  git checkout JIRI_HEAD 2> /dev/null
  builtin cd $FUCHSIA_DIR/scripts
  git checkout JIRI_HEAD 2> /dev/null
  jiri update

  builtin cd $FUCHSIA_DIR/zircon
  # remaster
  builtin cd $FUCHSIA_DIR/garnet
  # remaster

  builtin cd $FUCHSIA_DIR
end

function full_build
  fx full-build
end

function upload
  jiri upload
end

function zircon
  cd $FUCHSIA_DIR/zircon
end

function garnet
  cd $FUCHSIA_DIR/garnet
end
function garnet
  cd $FUCHSIA_DIR/garnet
end

function remaster
  git checkout JIRI_HEAD > /dev/null 2> /dev/null
  git branch -D master > /dev/null 2> /dev/null
  git checkout master > /dev/null 2> /dev/null
end

function start_ssh_agent
  set SSH_ENV $HOME/.ssh_agent_start
  echo "Initializing new SSH agent ..."
  ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
  echo "succeeded"
  chmod 600 $SSH_ENV
  . $SSH_ENV > /dev/null
  ssh-add
end


# Source local config
if test -e ~/.config/fish/config.fish.local
  source ~/.config/fish/config.fish.local
end


