function Get-DrmmAlert {

	<#
	.SYNOPSIS
	Fetches data of the alert identified by the given alert Uid.

	.DESCRIPTION
	Returns details of a specific alert.

	.PARAMETER AlertUid
	Provide alert uid which will be use to return alert details.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $alertUid
    )
    
	# Declare Variables
    $apiMethod = 'GET'

	# Return all alert details
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/alert/$alertUid" | ConvertFrom-Json

}