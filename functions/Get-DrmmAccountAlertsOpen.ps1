function Get-DrmmAccountAlertsOpen {

    <#
	.SYNOPSIS
	Fetches open alerts of the authenticated user's account

	.DESCRIPTION
	Returns account open alerts.

	.PARAMETER Muted
	Use this switch to show muted alerts

	#>


    # Function Parameters
    Param (
        [Parameter(Mandatory = $False)]
        [Switch]$muted
    )

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $Results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/alerts/open?max=$maxPage&page=$page&muted=$muted" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.Alerts
            $page++
        }
    }
    until ($null -eq $nextPageUrl)

    # Return all sites except the 'Deleted Devices' site
    return $Results

}