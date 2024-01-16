# Always stop on first error.
$ErrorActionPreference = "Stop"

# Load the helper functions.
. "$PSScriptRoot\helper_functions.ps1"

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
