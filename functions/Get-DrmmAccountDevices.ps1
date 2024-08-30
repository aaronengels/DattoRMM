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
		[Parameter(Mandatory=$False, ParameterSetName="FilterQuery")]
		[String]$FilterId,
		[Parameter(Mandatory=$False, ParameterSetName="Query")]
		[string]$hostname,
		[Parameter(Mandatory=$False, ParameterSetName="Query")]
		[string]$deviceType,
		[Parameter(Mandatory=$False, ParameterSetName="Query")]
		[string]$operatingSystem,
		[Parameter(Mandatory=$False, ParameterSetName="Query")]
		[string]$siteName
	)

	# Declare Variables
	$apiMethod = 'GET'
	$maxPage = 250
	$nextPageUrl = $null
	$page = 0
	$RequestUri = "/v2/account/devices?max=$maxPage&page=$page"

	# Process query params
	$queryParams = New-Object System.Collections.Generic.List[System.String]
	if ($FilterId) { $queryParams.Add("&filterId=$FilterId") }
	if ($hostname) { $queryParams.Add("&hostname=$hostname") }
	if ($deviceType) { $queryParams.Add("&deviceType=$deviceType") }
	if ($operatingSystem) { $queryParams.Add("&operatingSystem=$operatingSystem") }
	if ($siteName) { $queryParams.Add("&siteName=$siteName") }

	# Append the query parameters to the RequestUri
    if ($queryParams.Count -gt 0) {
        $RequestUri += [string]::Join('', $queryParams)
    }

	$Results = @()

	$Results = do {
		$Response = New-ApiRequest -apiMethod $apiMethod -apiRequest $RequestUri | ConvertFrom-Json
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