function Get-DrmmDefaultFilters {

	<#
	.SYNOPSIS
	Fetches default device filters.

	.DESCRIPTION
	Returns all default device filters.

	#>
    
    
	# Declare Variables
    $apiMethod = 'GET'

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    $results = do {
        $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/filter/default-filters?max=$maxPage&page=$page" | ConvertFrom-Json
        if ($Response) {
            $nextPageUrl = $Response.pageDetails.nextPageUrl
            $Response.filters
            $page++
        }
    }
    until ($null -eq $nextPageUrl)
	return $results

}