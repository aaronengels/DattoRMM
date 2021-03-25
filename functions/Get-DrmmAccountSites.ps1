function Get-DrmmAccountSites {

    <#
	.SYNOPSIS
	Fetches the site records of the authenticated user's account.

	.DESCRIPTION
	Returns account site settings, device Status and proxy Settings.

	.PARAMETER NoDeletedDevices
	Do not return the 'Deleted Devices' site settings.

	#>

    # Function Parameters
    Param (
        
        [Parameter(Mandatory = $False)]
        [Switch]$noDeletedDevices
    )

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/sites?max=$maxPage&page=$page" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.Sites
            $page++
        }
    }
    until ($null -eq $nextPageUrl)

    # Return all sites except the 'Deleted Devices' site
    if ($noDeletedDevices) {    
        return $Results | Where-Object name -ne 'Deleted Devices'
    }
    else {
        return $Results
    }
}