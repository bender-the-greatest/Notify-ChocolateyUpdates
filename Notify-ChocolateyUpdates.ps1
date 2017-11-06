Import-Module -Name BurntToast
$ErrorActionPreference = "Stop"

# Get list of outdated packages
$outdated = & choco outdated

# Make sure `choco outdated` worked
if ( $LASTEXITCODE -ne 0 ) {
  New-BurntToastNotification `
    -Text "Failed to check package updates", "``choco outdated`` returned ${LASTEXITCODE}"
  exit 1
}

# Get unpinned packages first
$packageUpdates = ( $outdated | `
  Select-Object -Skip 4 | `
  Select-Object -SkipLast 2 | `
  Where-Object {
    $_.ToLower().EndsWith( 'false' )
  } | Select-String '^([^|]+)|.*$' ).Matches.Value

# Get pinned packages count
$pinnedUpdateCount = ( ( $outdated | `
  Select-Object -Skip 4 | `
  Select-Object -SkipLast 2 | `
  Where-Object {
    $_.ToLower().EndsWith( 'true' )
  } | Select-String '^([^|]+)|.*$' ).Matches.Value ).Count

# Join outdated packages into a single string
$packageString = $packageUpdates -Join ', '

# Send the notification
If ( $packageUpdates.count -gt 0 ) {
  $titleString = "Chocolatey package updates available"
  if ( $pinnedUpdateCount -gt 0 ) {
    $titleString += " (${pinnedUpdateCount} hidden)"
  }
  New-BurntToastNotification -Text $titleString, $packageString
}
