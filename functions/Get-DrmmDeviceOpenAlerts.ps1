function Get-DrmmDeviceOpenAlerts {

	<#
	.SYNOPSIS
	Fetches the open alerts of the device identified by the given device Uid.

	.DESCRIPTION
	Returns the open alerts of a particular device.

	.PARAMMETER deviceUid
	Provide device uid which will be used to return device open alerts.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
    )
	
	# Validate device UID
	if($deviceUid.GetType().Name -ne 'String') {
		return 'The Device UID is not a String!'
	}
	elseif($deviceUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Device UID format is incorrect!'
	}
	
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
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