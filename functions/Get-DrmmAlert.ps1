function Get-DrmmAlert {

	<#
	.SYNOPSIS
	Fetches data of the alert identified by the given alert Uid.

	.DESCRIPTION
	Returns details of a specific alert.

	.PARAMMETER alertUid
	Provide alert uid which will be use to return alert details.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $alertUid
    )
    
	# Validate Alert UID
	if($alertUid.GetType().Name -ne 'String') {
		return 'The Alert UID is not a String!'
	}
	elseif($alertUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Alert UID format is incorrect!'
	}

	# Declare Variables
    $apiMethod = 'GET'

	# Return all alert details
	$Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/alert/$alertUid" | ConvertFrom-Json
	return $Response

}