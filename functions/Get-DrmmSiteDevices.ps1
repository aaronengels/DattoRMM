function Get-DrmmSiteDevices {

	<#
	.SYNOPSIS
	Fetches the devices records of the site identified by the given site uid.

	.DESCRIPTION
	Returns device settings, device type, device anti-virus status, device patch Status and UDF's.

	.PARAMETER SiteUid
	Provide site uid which will be use to return this site devices.
	
	.PARAMETER FilterId
	Optional parameter specifying a filter to return only some devices 
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)]
		[String]$siteUid,
		
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

	$results =    do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/devices?max=$maxPage&page=$page$filterQuery" | ConvertFrom-Json
	    if ($Response) {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		$Response.devices
		    $page++
	    }
    }
    until ($null -eq $nextPageUrl)

    # Return all site devices
    return $Results

}