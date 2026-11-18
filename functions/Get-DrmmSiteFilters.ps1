function Get-DrmmSiteFilters {

	<#
	.SYNOPSIS
	Fetches the device filters of the site identified by the given site Uid.

	.DESCRIPTION
	Returns the site's device filters (those visible with the administrator role): id, name,
	description, type and dates. The id can be passed to Get-DrmmSiteDevices -FilterId.

	.PARAMETER SiteUid
	Provide site uid which will be used to return the site filters.

	.PARAMETER Name
	Optionally return only the filter with this name.

	.EXAMPLE
	$filter = Get-DrmmSiteFilters -siteUid $uid -Name 'Servers'
	Get-DrmmSiteDevices -siteUid $uid -FilterId $filter.id

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$True)]
		[ValidateNotNullOrEmpty()]
		[string]$siteUid,

		[Parameter(Mandatory=$False)]
		[string]$Name
	)

	$apiRequest = '/v2/site/{0}/filters' -f [uri]::EscapeDataString($siteUid)
	$Results = New-ApiPagedRequest -apiRequest $apiRequest -resultProperty 'filters'

	# Return the named filter, or all site filters
	if ($PSBoundParameters.ContainsKey('Name')) {
		return $Results | Where-Object { $_.name -eq $Name }
	}
	return $Results
}
