function Get-DrmmDeviceAudit {

	<#
	.SYNOPSIS
	Fetches audited software of the generic device identified the given device Uid.

	.DESCRIPTION
	Returns software audit.

	.PARAMETER deviceUid
	Provide device uid which will be used to return device software audit data.

	.PARAMETER page
	Provide the requested page from pagination.
	
	.PARAMETER max
	Provide the max amount of items per page for pagination.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,
        [Parameter(Mandatory=$False)] 
		$page,
		[Parameter(Mandatory=$False)] 
        $max
    )
	
	# Validate device UID
	if($deviceUid.GetType().Name -ne 'String') {
		return 'The Device UID is not a String!'
	}
	elseif($deviceUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Device UID format is incorrect!'
	}
	
    # Declare Variables
    $apiMethod = 'GET'
    
	# Return device audit data
    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/audit/device/$deviceUid/software" | ConvertFrom-Json
	return $Response

}