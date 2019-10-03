function install_plugins --description "Install all the plugins in a given file"
  while read -la line
    fisher $line
  end < $argv
end
