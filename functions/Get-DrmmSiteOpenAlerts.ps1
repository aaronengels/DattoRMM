function Get-DrmmSiteOpenAlerts {

	<#
	.SYNOPSIS
	Fetches the open alerts of the site identified by the given site Uid.

	.PARAMMETER siteUid
	Provide site uid which will be used to return device open alerts.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $siteUid
    )
	
	# Validate device UID
	if($siteUid.GetType().Name -ne 'String') {
		return 'The Site UID is not a String!'
	}
	elseif($siteUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Site UID format is incorrect!'
	}
	
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/alerts/open?max=$maxPage&page=$page" | ConvertFrom-Json
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