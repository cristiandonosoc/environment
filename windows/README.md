# Environment install for Windows

These are the instructions for setting my common development setup for Windows.

1. Install git for windows, with "git credentials manager"
2. clone https://github.com/cristiandonosoc/environment
3. Install neovim: https://github.com/neovim/neovim/wiki/Installing-Neovim
4. Run windows\setup_vim.ps1
	- Remember the execution bypass for powershell scripts.
	- TODO(cdc): You might need to re-run the script because pip might not be loaded
	             into PATH since it's been installed in the same environment.
5. Within nvim, run "PlugInstall"
6. Compile YouCompleteMe
