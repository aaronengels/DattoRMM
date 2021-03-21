function Get-DrmmSiteResolvedAlerts {

    <#
	.SYNOPSIS
	Fetches the resolved alerts of the device identified by the given site Uid.

	.PARAMETER SiteUid
	Provide site uid which will be used to return device resolved alerts.
	
	#>
    
    # Function Parameters
    Param (
        [Parameter(Mandatory = $True)] 
        $siteUid
    )
	
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/alerts/resolved?max=$maxPage&page=$page" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.alerts
            $page++
        }
    }
    until ($null -eq $nextPageUrl)

    # Return all site resolved alerts
    return $Results

}