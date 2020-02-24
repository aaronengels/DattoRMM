function Get-DrmmDeviceOpenAlerts {

	<#
	.SYNOPSIS
	Fetches the open alerts of the device identified by the given device Uid.

	.DESCRIPTION
	Returns the open alerts of a particular device.

	.PARAMETER deviceUid
	Provide device uid which will be used to return device open alerts.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
    )
	
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/alerts/open?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response) {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.alerts
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all site devices
    return $Results

}