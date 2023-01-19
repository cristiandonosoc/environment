# These are all helper functions that are used around the setup scripts.

# Make-Dir is a helper function that creates a directory and logs some nice stuff.
function Make-Dir {
	param(
		[parameter(Mandatory)]
		[string]$Dir
	)

	if (Test-Path -Path $Dir) {
		Write-Host "MKDIR ${Dir}: already exists."
		return Resolve-Path -Path $Dir
	}

	New-Item -Path $Dir -ItemType directory -Force | Out-Null
	Write-Host "MKDIR ${Dir}: created."

	return Resolve-Path -Path $Dir
}

# Copy-File is a helper function that creates a directory and logs some nice stuff.
function Copy-File {
	param(
		[parameter(Mandatory)]
		[string]$From,
		[parameter(Mandatory)]
		[string]$To,
		[parameter(Mandatory=$false)]
		[bool]$Silent = $false
	)

	# We ensure the from path is complete.
	$From = Resolve-Path -Path $From

	# If the target file exists, we check the hashes to see if we need to copy.
	if (Test-Path -Path $To) {
		if ($(Get-FileHash -Path $From).Hash -eq $(Get-FileHash -Path $To).Hash) {
			if (!$Silent) {
				Write-Host "COPY $From -> ${To}: Files are identical. No copy."
			}
			return Resolve-Path -Path $To
		}
	}

	Copy-Item $From -Destination $To
	Write-Host "COPY $From -> ${To}: Copied file."
	return Resolve-Path -Path $To
}


