function Get-DrmmSitePatches {

	<#
	.SYNOPSIS
	Fetches the patches of all devices in the site identified by the given site Uid.

	.DESCRIPTION
	Returns one record per patch with full patch metadata, its install status and the number of
	devices in the site it applies to (totalDevices). Requires Datto RMM 15.1.0 or later.

	.PARAMETER SiteUid
	Provide site uid which will be used to return the site patches.

	.PARAMETER InstallStatus
	Optionally return only patches with this install status: INSTALLED, APPROVED_PENDING or NOT_APPROVED.

	.EXAMPLE
	Get-DrmmSitePatches -siteUid $uid -InstallStatus NOT_APPROVED

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$True)]
		[ValidateNotNullOrEmpty()]
		[string]$siteUid,

		[Parameter(Mandatory=$False)]
		[ValidateSet('INSTALLED', 'APPROVED_PENDING', 'NOT_APPROVED')]
		[string]$InstallStatus
	)

	$apiRequest = '/v2/site/{0}/patches' -f [uri]::EscapeDataString($siteUid)
	if ($InstallStatus) {
		$apiRequest += '?installStatus={0}' -f $InstallStatus.ToUpperInvariant()
	}

	# Return all site patches
	return New-ApiPagedRequest -apiRequest $apiRequest -resultProperty 'patches'
}
