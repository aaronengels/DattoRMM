function Get-DrmmDeviceAudit {

	<#
	.SYNOPSIS
	Fetches audit data of the generic device identified the given device Uid.

	.DESCRIPTION
	Returns attaced devices, baseBoard, bios, displays, logicalDisks, mobileInfo, nics, processors, snmpInfo, systemInfo, videoBoards.

	.PARAMMETER deviceUid
	Provide device uid which will be used to return device audit data.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
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
    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/audit/device/$deviceUid" | ConvertFrom-Json
	return $Response

}