function Get-DrmmSystemStatus {

	<#
	.SYNOPSIS
	Fetches the Datto RMM API system status.

	.DESCRIPTION
	Returns the API version (including build), status and start date of the platform the module is
	connected to. Useful as a connectivity check after Set-DrmmApiParameters.

	.EXAMPLE
	Get-DrmmSystemStatus

	#>

	# Return system status
	return New-ApiRequest -apiMethod 'GET' -apiRequest '/v2/system/status' | ConvertFrom-Json
}
