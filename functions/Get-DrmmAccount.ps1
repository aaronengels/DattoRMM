function Get-DrmmAccount {

	<#
	.SYNOPSIS
	Fetches the authenticated user's account data.

	.DESCRIPTION
	Returns account settings, descriptor and account device status.
	
	#>

    # Declare Variables
    $apiMethod = 'GET'
	
	# Return all account settings
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/" | ConvertFrom-Json

}