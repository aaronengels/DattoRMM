function Get-DrmmCustomFilters {

	<#
	.SYNOPSIS
	Fetches custom device filters.

	.DESCRIPTION
	Returns all custom device filters that are viewable by the account as administrator.

    .PARAMETER Name
    Optional parameter to return a filter with a specific name
    #>
    
    # Function Parameters
    Param (
        [Parameter(Mandatory=$False)]
        [String]$Name
    )
    
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/filter/custom-filters?max=$maxPage&page=$page" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.filters
            $page++
        }
    }
    until ($null -eq $nextPageUrl)
    
    if ( $PSBoundParameters.ContainsKey("Name") ) {
        return $results | Where-Object { $_.name -eq $Name }
    }
    
    return $results

}