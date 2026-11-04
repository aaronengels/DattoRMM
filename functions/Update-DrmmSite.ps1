function Update-DrmmSite {

	<#
	.SYNOPSIS
	Updates only the given settings of the site identified by the given site Uid, keeping the rest.

	.DESCRIPTION
	The site update endpoint (POST /v2/site/{siteUid}) resets every setting that isn't sent: calling
	Set-DrmmSite with only -siteName clears the description and notes and turns off onDemand and
	splashtopAutoInstall.
	Update-DrmmSite reads the site first, applies only the parameters you supply and sends the full
	set back, so settings you don't mention keep their current values.

	.PARAMETER SiteUid
	Provide site uid of the site to update.

	.PARAMETER SiteName
	New site name.

	.PARAMETER SiteDescription
	New site description. Pass '' to clear it.

	.PARAMETER SiteNotes
	New site notes. Pass '' to clear them.

	.PARAMETER OnDemand
	$true to mark the site as an on-demand site, $false to unmark it.

	.PARAMETER SplashtopAutoInstall
	$true to switch Splashtop auto-install on, $false to switch it off.

	.EXAMPLE
	Update-DrmmSite -siteUid $uid -siteNotes 'Moved to new office 2026-11'
	Changes only the notes; name, description, onDemand and splashtopAutoInstall are kept.

	.EXAMPLE
	Update-DrmmSite -siteUid $uid -siteName 'Contoso Ltd' -WhatIf
	Shows the change without making it.

	#>

	# Function Parameters
	[CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
	Param (
		[Parameter(Mandatory=$True, Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$siteUid,

		[Parameter(Mandatory=$False)]
		[ValidateNotNullOrEmpty()]
		[string]$siteName,

		[Parameter(Mandatory=$False)]
		[AllowEmptyString()]
		[string]$siteDescription,

		[Parameter(Mandatory=$False)]
		[AllowEmptyString()]
		[string]$siteNotes,

		[Parameter(Mandatory=$False)]
		[bool]$onDemand,

		[Parameter(Mandatory=$False)]
		[bool]$splashtopAutoInstall
	)

	# Map each parameter to its field in the site update request
	$fieldMap = [ordered]@{
		siteName             = 'name'
		siteDescription      = 'description'
		siteNotes            = 'notes'
		onDemand             = 'onDemand'
		splashtopAutoInstall = 'splashtopAutoInstall'
	}
	$changes = @($fieldMap.Keys | Where-Object { $PSBoundParameters.ContainsKey($_) })
	if ($changes.Count -eq 0) {
		Write-Warning "Update-DrmmSite : no settings supplied for site $siteUid, nothing to update. Pass at least one of -$($fieldMap.Keys -join ', -')."
		return
	}

	# Read the current settings so the ones not supplied are sent back unchanged
	$siteUidPath = [uri]::EscapeDataString($siteUid)
	$current = New-ApiRequest -apiMethod 'GET' -apiRequest "/v2/site/$siteUidPath" | ConvertFrom-Json
	if (-not $current) {
		Write-Error "Update-DrmmSite : could not read site $siteUid, so it was not updated. Check the site uid and that the API user can view the site."
		return
	}

	$updateSiteRequest = [ordered]@{
		name                 = $current.name
		description          = $current.description
		notes                = $current.notes
		onDemand             = [bool]$current.onDemand
		splashtopAutoInstall = [bool]$current.splashtopAutoInstall
	}
	foreach ($parameter in $changes) {
		$updateSiteRequest[$fieldMap[$parameter]] = $PSBoundParameters[$parameter]
	}

	# Convert to JSON
	$Body = $updateSiteRequest | ConvertTo-Json

	# Update site and return results
	$changedFields = ($changes | ForEach-Object { $fieldMap[$_] }) -join ', '
	if (-not $PSCmdlet.ShouldProcess("site '$($current.name)' ($siteUid)", "Update $changedFields")) { return }
	return New-ApiRequest -apiMethod 'POST' -apiRequest "/v2/site/$siteUidPath" -apiRequestBody $Body | ConvertFrom-Json
}
