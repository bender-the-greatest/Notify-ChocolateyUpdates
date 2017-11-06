[CmdletBinding()]
Param()

$ErrorActionPreference = "Stop"
Import-Module -Name BurntToast -Verbose:$false

$appLogo = 'nonexistant'

# Get list of outdated packages
Write-Verbose 'Getting list of outdated packages'
$outdated = & choco outdated 2>&1

# Verbose output
Write-Verbose "``choco outdated`` output:"
Write-Verbose ''
$outdated | Foreach-Object {
  $line = $_
  Write-Verbose "`t`t${line}"
}
Write-Verbose ''

# Make sure `choco outdated` worked
if ( $LASTEXITCODE -ne 0 ) {
  Write-Verbose 'Failed to check outdated packages, creating notification'
  New-BurntToastNotification `
    -Text "Failed to check package updates", "``choco outdated`` returned ${LASTEXITCODE}"
  Write-Verbose
  exit 1
}

# Get unpinned packages first
$packageUpdates = ( $outdated | `
  Select-Object -Skip 4 | `
  Select-Object -SkipLast 2 | `
  Where-Object {
    $_.ToLower().EndsWith( 'false' )
  } | Select-String '^([^|]+)|.*$' ).Matches.Value

# Join outdated packages into a single string
$packageString = $packageUpdates -Join ', '
Write-Verbose "Packages to update: ${packageString}"

# Get pinned packages count
$pinnedUpdateCount = ( ( $outdated | `
  Select-Object -Skip 4 | `
  Select-Object -SkipLast 2 | `
  Where-Object {
    $_.ToLower().EndsWith( 'true' )
  } | Select-String '^([^|]+)|.*$' ).Matches.Value ).Count

# Send the notification
if ( $packageUpdates.count -gt 0 ) {
  $titleString = "Chocolatey package updates available"

  if ( $pinnedUpdateCount -gt 0 ) {
    Write-Verbose "${pinnedUpdateCount} pinned packages held back"
    $titleString += " (${pinnedUpdateCount} hidden)"
  }

  Write-Verbose 'Creating notification'
  New-BurntToastNotification -Text $titleString, $packageString `
    -AppLogo $nonexistant
}
