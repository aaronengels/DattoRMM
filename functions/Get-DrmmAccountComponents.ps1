function Get-DrmmAccountComponents {

	<#
	.SYNOPSIS
	Fetches the components records of the authenticated user's account.

	.DESCRIPTION
	Returns account installed components.
	#>

	# Declare Variables
	$apiMethod = 'GET'
	$maxPage = 250
	$nextPageUrl = $null
	$page = 0
	$Results = @()

	$results = do {
		$Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/components?max=$maxPage&page=$page" | ConvertFrom-Json
		if ($Response) {
			$nextPageUrl = $Response.pageDetails.nextPageUrl
			$Response.components
			$page++
		}
	}
	until ($null -eq $nextPageUrl)

	# Return all account installed components
	return $Results
}