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
        [Switch]$noDeletedDevices,
        [Parameter(Mandatory = $False)]
        [string]$siteName
    )

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $RequestUri = "/v2/account/sites?max=$maxPage&page=$page"

	# Process query params
	$queryParams = New-Object System.Collections.Generic.List[System.String]
	if ($siteName) { $queryParams.Add("&siteName=$siteName") }

	# Append the query parameters to the RequestUri
    if ($queryParams.Count -gt 0) {
        $RequestUri += [string]::Join('', $queryParams)
    }

    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest $RequestUri | ConvertFrom-Json
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