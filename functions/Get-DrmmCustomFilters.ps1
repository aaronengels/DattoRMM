function Get-DrmmCustomFilters {

	<#
	.SYNOPSIS
	Fetches custom device filters.

	.DESCRIPTION
	Returns all custom device filters that are viewable by the account as administrator.

	#>

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
	return $results

}