# Always stop on first error.
$ErrorActionPreference = "Stop"

# Load the helper functions.
. "$PSScriptRoot\helper_functions.ps1"

Write-Host "Hello $env:UserName, your home dir is $HOME"
Write-Host "Script location: $PSScriptRoot"

Write-Host "---------------------------------------------------------------------------------------"

# Configure git to use the credential manager.
Write-Host "GIT Setting global configs"
git config --global credential.helper manager-core

# Configure nvim-qt to be the editor so that we can invoke it from cli nvim.
git config --global core.editor "nvim-qt"

# Check for pynvim module.
if ($(python -m pip list | Select-String "pynvim")) {
	Write-Host "NEOVIM PYTHON MODULE: already installed."
} else {
	python -m pip install --user pynvim
}

# Install the nvim config.
$nvimInitDir = Make-Dir -Dir "$HOME\AppData\Local\nvim"
$nvimInitPath = Copy-File -From "$PSScriptRoot\..\common\nvim.init.lua" -To "$nvimInitDir\init.lua"

# Create the directories used by our vim setup to track swap, undo and other runtime metadata.
Make-Dir -Dir "$HOME\.nvim\cache\swap" | Out-Null
Make-Dir -Dir "$HOME\.nvim\cache\backup" | Out-Null
Make-Dir -Dir "$HOME\.nvim\cache\undo" | Out-Null

# Copy our vimrcs.
Copy-File -From "$PSScriptRoot\..\common\vimrc" -To "$HOME\.vimrc" | Out-Null
Copy-File -From "$PSScriptRoot\..\common\vimrc_extras.vim" -To "$HOME\.vimrc.extras" | Out-Null
Copy-File -From "$PSScriptRoot\windows_vimrc" -To "$HOME\.vimrc.windows" | Out-Null
Copy-File -From "$PSScriptRoot\.ideavimrc" -To "$HOME\.ideavimrc" | Out-Null

# Download vim-plug
$plugPath = "$HOME/.nvim/autoload/plug.vim"
if (Test-Path -Path $plugPath) {
	Write-Host "VIMPLUG: Already exists. Skipping download."
} else {
	Write-Host "DOWNLOAD plug.vim"
	iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/.nvim/autoload/plug.vim -Force
}

# Setup coreutils wrappers
$coreutilsElements = @(
  "arch", "b2sum", "b3sum", "base32", "base64", "basename", "basenc", "cat", "cksum", "comm", "cp",
	"csplit", "cut", "date", "dd", "df", "dir", "dircolors", "dirname", "du", "echo", "env", "expand",
	"expr", "factor", "false", "fmt", "fold", "hashsum", "head", "hostname", "join", "link", "ln",
	"ls", "md5sum", "mkdir", "mktemp", "more", "mv", "nl", "nproc", "numfmt", "od", "paste", "pr",
	"printenv", "printf", "ptx", "pwd", "readlink", "realpath", "relpath", "rm", "rmdir", "seq",
	"sha1sum", "sha224sum", "sha256sum", "sha3-224sum", "sha3-256sum", "sha3-384sum", "sha3-512sum",
	"sha384sum", "sha3sum", "sha512sum", "shake128sum", "shake256sum", "shred", "shuf", "sleep",
	"sort", "split", "sum", "sync", "tac", "tail", "tee", "test", "touch", "tr", "true", "truncate",
	"tsort", "unexpand", "uniq", "unlink", "vdir", "wc", "whoami", "yes"
)

# Ensure the bin directory exits.
$bindir = "C:\cdc\bin"
Make-Dir -Dir $bindir | Out-Null
Make-Dir -Dir "$bindir\coreutils" | Out-Null

# Copy over the coreutils wrappers.
Write-Host "INSTALL coretutils (if needed)."
$coreutilsElements | ForEach-Object {
	$From = "$PSScriptRoot\coreutil_wrapper.bat"
	$To = "$bindir\coreutils\$PSItem.bat"
	Copy-File -From $From -To $To -Silent $true | Out-Null
}
