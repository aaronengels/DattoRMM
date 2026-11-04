function Get-DrmmSystemRequestRate {

	<#
	.SYNOPSIS
	Fetches the API request rate status for the authenticated user's account.

	.DESCRIPTION
	Returns the account's current read and write request counts and limits over the sliding time window:
	accountCount / accountRateLimit (reads), accountWriteCount / accountWriteRateLimit (writes),
	slidingTimeWindowSizeSeconds, accountCutOffRatio (the share of the limit at which the API starts to
	slow requests down) and operationWriteStatus (per-operation write counts).
	Limits are counted across the whole account, not per API user.

	.EXAMPLE
	$rate = Get-DrmmSystemRequestRate
	"{0} of {1} writes used" -f $rate.accountWriteCount, $rate.accountWriteRateLimit

	#>

	# Return request rate status
	return New-ApiRequest -apiMethod 'GET' -apiRequest '/v2/system/request_rate' | ConvertFrom-Json
}
