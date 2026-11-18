function Get-DrmmSystemPagination {

	<#
	.SYNOPSIS
	Fetches the API pagination configuration.

	.DESCRIPTION
	Returns the maximum number of items the API returns per page (max).

	.EXAMPLE
	(Get-DrmmSystemPagination).max

	#>

	# Return pagination configuration
	return New-ApiRequest -apiMethod 'GET' -apiRequest '/v2/system/pagination' | ConvertFrom-Json
}
