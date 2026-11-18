function New-ApiPagedRequest {

	<#
	.SYNOPSIS
	Makes a paged GET API request and returns every item from every page.

	.DESCRIPTION
	Requests page 0, 1, 2 ... (250 items per page, the API maximum) until the response has no
	nextPageUrl, and outputs the items found in the given response property.
	Stops after the first failed request instead of retrying the same page; New-ApiRequest has
	already reported the error.

	.PARAMETER apiRequest
	The request path, optionally with its own query string, e.g. "/v2/site/$siteUid/patches?installStatus=INSTALLED".
	The page and max parameters are added by this function.

	.PARAMETER resultProperty
	The response property that holds the items, e.g. 'patches'.

	.OUTPUTS
	The items from every page.

	#>

	Param(
		[Parameter(Mandatory = $True)]
		[string]$apiRequest,

		[Parameter(Mandatory = $True)]
		[string]$resultProperty
	)

	$maxPage = 250
	$page = 0
	$separator = if ($apiRequest.Contains('?')) { '&' } else { '?' }

	do {
		$Response = New-ApiRequest -apiMethod 'GET' -apiRequest "$apiRequest$($separator)max=$maxPage&page=$page" | ConvertFrom-Json
		if (-not $Response) {
			break
		}
		$Response.$resultProperty
		$page++
	}
	while ($Response.pageDetails.nextPageUrl)
}
