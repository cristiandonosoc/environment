#! /bin/sh

function Prompt() {
  read -p "Install $1? [Y/n]: " response

  if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
    return 0
  fi
  return 1
}



# NEOVIM
################################################################################


# if [[ -z Prompt("Neovim") ]]; then
#   echo "INSTALLING NEOVIM!"
# fi


if Prompt "Neovim"; then
  echo "INSTALLING NEOVIM!"

fi
