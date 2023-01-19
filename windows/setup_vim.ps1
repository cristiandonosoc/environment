Write-Host "Hello $env:UserName, your home dir is $HOME"
Write-Host "Script location: $PSScriptRoot"

function Declare-Replacement {
	param(
		[parameter(Mandatory)]
		[string]$From,
		[parameter(Mandatory)]
		[string]$To
	)

	# We make the paths absolute.
	$From = Resolve-Path -Path $From

	# Verify that the from location exists.
	$fromCheck = Test-Path -Path $From -PathType leaf
	if ($fromCheck -eq $false) {
		throw "From path $From does not exist"
	}

	Write-Host "- $From -> $To"
}

# Make-Dir is a helper function that creates a directory and logs some nice stuff.
function Make-Dir {
	param(
		[parameter(Mandatory)]
		[string]$Dir
	)

	Write-Host "MKDIR $Dir"
	New-Item -Path $Dir -ItemType directory -Force | Out-Null
	Write-Host "-> DONE"

	return Resolve-Path -Path $Dir
}

# Copy-File is a helper function that creates a directory and logs some nice stuff.
function Copy-File {
	param(
		[parameter(Mandatory)]
		[string]$From,
		[parameter(Mandatory)]
		[string]$To
	)

	$From = Resolve-Path -Path $From
	Write-Host "COPY $From -> $To"
	Copy-Item $From -Destination $To
	Write-Host "-> DONE"

	return Resolve-Path -Path $To
}

Write-Host "Actions:"
Write-Host ""


# Configure git to use the credential manager.
git config --global credential.helper manager-core

# Install Python 3.9
Write-Host "INSTALL Python 3.9"
winget install -e --id Python.Python.3.9

# Install neovim pip module (might require re-bash)
pip install --user pynvim

# Install the nvim config.
$nvimInitDir = Make-Dir -Dir "$HOME\AppData\Local\nvim"
$nvimInitPath = Copy-File -From "$PSScriptRoot\..\nvim.init.vim" -To "$nvimInitDir\init.vim"

# Create the directories used by our vim setup to track swap, undo and other runtime metadata.
Make-Dir -Dir "$HOME\.nvim\cache\swap" | Out-Null
Make-Dir -Dir "$HOME\.nvim\cache\backup" | Out-Null
Make-Dir -Dir "$HOME\.nvim\cache\undo" | Out-Null

# Copy our vimrcs.
Copy-File -From "$PSScriptRoot\..\vimrc" -To "$HOME\.vimrc" | Out-Null
Copy-File -From "$PSScriptRoot\..\vimrc_extras.vim" -To "$HOME\.vimrc.extras" | Out-Null
Copy-File -From "$PSScriptRoot\windows_vimrc" -To "$HOME\.vimrc.windows" | Out-Null

# Download vim-plug
$plugPath = "$HOME/.nvim/autoload/plug.vim"
if ($(Test-Path -Path $plugPath) -eq $false) {
	Write-Host "DOWNLOAD plug.vim"
	iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/.nvim/autoload/plug.vim -Force
	Write-Host "-> DONE"
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
$coreutilsElements | ForEach-Object {
	Copy-File -From "$PSScriptRoot\coreutil_wrapper.bat" -To "$bindir\coreutils\$PSItem.bat" | Out-Null
}
