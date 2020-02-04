function Get-DrmmAccount {

	<#
	.SYNOPSIS
	Fetches the authenticated user's account data.

	.DESCRIPTION
	Returns account settings, descriptor and account device status.
	
	#>

    # Declare Variables
    $apiMethod = 'GET'
    $Results = @()
	
	# Return all account settings
	return $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/" | ConvertFrom-Json

}