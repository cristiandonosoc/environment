# This script is meant to collect changes from the "wild" and past them into the repo.
# Useful to collect changes that have ocurred on a machine after some time developing on it.

# Always stop on first error.
$ErrorActionPreference = "Stop"

# Load the helper functions.
. "$PSScriptRoot\helper_functions.ps1"

Write-Host "Hello $env:UserName, your home dir is $HOME"
Write-Host "Script location: $PSScriptRoot"

Write-Host "---------------------------------------------------------------------------------------"

Copy-File -From "$HOME\AppData\Local\nvim\init.lua" -To "$PSScriptRoot\..\common\nvim.init.lua" | Out-Null
Copy-File -From "$HOME\.vimrc" -To "$PSScriptRoot\..\common\vimrc" | Out-Null
Copy-File -From "$HOME\.vimrc.extras" -To "$PSScriptRoot\..\common\vimrc_extras.vim" | Out-Null
Copy-File -From "$HOME\.vimrc.windows" -To "$PSScriptRoot\windows_vimrc" | Out-Null
Copy-File -From "$HOME\.ideavimrc" -To "$PSScriptRoot\.ideavimrc" | Out-Null
