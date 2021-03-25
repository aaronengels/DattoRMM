function Get-DrmmSiteVariables {

    <#
	.SYNOPSIS
	Gets account variables.
    
    .PARAMETER siteUid
    The UID of the site for which to get variables.
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
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/variables?max=$maxPage&page=$page" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.variables
            $page++
        }
    }
    until ($null -eq $nextPageUrl)

    # Return all account devices
    return $Results
} 