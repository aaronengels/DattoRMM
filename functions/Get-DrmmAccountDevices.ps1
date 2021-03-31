function Get-DrmmAccountDevices {

	<#
	.SYNOPSIS
	Fetches the devices of the authenticated user's account.

	.DESCRIPTION
	Returns device data, including patch status, anti-virus status and user defined fields.
	
	.PARAMETER FilterId
	Optional parameter specifying a filter to return only some devices 
	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$False)]
		[String]$FilterId
	)

	# Declare Variables
	$apiMethod = 'GET'
	$maxPage = 250
	$nextPageUrl = $null
	$page = 0
	if ( $PSBoundParameters.ContainsKey("FilterId") ) {
		$filterQuery = "&filterId=$FilterId"
	}
	$Results = @()

	$Results = do {
		$Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/devices?max=$maxPage&page=$page$filterQuery" | ConvertFrom-Json
		if ($Response) {
			$nextPageUrl = $Response.pageDetails.nextPageUrl
			$Response.devices
			$page++
		}
	}
	until ($null -eq $nextPageUrl)

	# Return all account devices
	return $Results
}