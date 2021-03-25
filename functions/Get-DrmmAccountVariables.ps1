function Get-DrmmAccountVariables {

    <#
	.SYNOPSIS
	Gets account variables.
	
	#>

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/variables?max=$maxPage&page=$page" | ConvertFrom-Json
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