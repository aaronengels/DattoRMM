function Get-DrmmDeviceResolvedAlerts {

    <#
	.SYNOPSIS
	Fetches the resolved alerts of the device identified by the given device Uid.

	.DESCRIPTION
	Returns the resolved alerts of a particular device.

	.PARAMETER DeviceUid
	Provide device uid which will be used to return device resolved alerts.
	
	#>
    
    # Function Parameters
    Param (
        [Parameter(Mandatory = $True)] 
        $deviceUid
    )
	
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/alerts/resolved?max=$maxPage&page=$page" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.alerts
            $page++
        }
    }
    until ($null -eq $nextPageUrl)

    # Return all site devices
    return $Results

}