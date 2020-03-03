function Get-DrmmDevice {

	<#
	.SYNOPSIS
	Fetches data of the device identified by the given device Uid

	.DESCRIPTION
	Returns device settings, device type, device anti-virus status, device patch Status and UDF's.

	.PARAMETER DeviceUid
	Provide device uid which will be used to return device data.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
    )
	
    # Declare Variables
    $apiMethod = 'GET'
    
	# Return device data
    return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid" | ConvertFrom-Json

}