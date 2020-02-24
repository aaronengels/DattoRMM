function Set-DrmmAlertResolve {

	<#
	.SYNOPSIS
	Resolves the alert identified by the given alert Uid.

	.DESCRIPTION
	Resolve alert providing the alert Uid.

	.PARAMETER alertUid
	Provide alert Uid to resolve the alert.
	
	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $alertUid
    )
	
	# Declare Variables
		$apiMethod = 'POST'

	# Resolve Alert
	New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/alert/$alertUid/resolve"

}