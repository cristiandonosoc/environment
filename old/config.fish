# Paths
set PATH ~/Local/bin $PATH
set PATH /usr/local/go/bin $PATH

# aliases
alias ll "ls -lha"
alias grep "grep --color"
alias p4 "p4.exe"
alias terraform "terraform.exe"
set -g EDITOR nvim

# Bob-the-fish
set -g theme_newline_cursor yes             # 2 lines prompt
#set -g theme_display_git yes                # Display git status
#set -g theme_display_git_master_branch yes  # Display "master" name in git display
set -g theme_show_exit_status yes           # Show status code of last command
#set -g theme_display_git_dirty_verbose yes  # Amount

# Prompt doesn't abbreviate paths
set -g fish_prompt_pwd_dir_length 0

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
