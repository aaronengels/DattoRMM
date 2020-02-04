function Get-DrmmDevice {

	<#
	.SYNOPSIS
	Fetches data of the device identified by the given device Uid

	.DESCRIPTION
	Returns device settings, device type, device anti-virus status, device patch Status and UDF's.

	.PARAMMETER deviceUid
	Provide device uid which will be used to return device data.
	
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
    
	# Return device data
    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid" | ConvertFrom-Json
	return $Response

}