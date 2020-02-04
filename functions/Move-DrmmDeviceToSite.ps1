function Move-DrmmDeviceToSite {

	<#
	.SYNOPSIS
	Moves a device from one site to another site.

	.PARAMETER deviceUid
	Provide device uid which of device you woul dlike to move.

	.PARAMMETER siteUid
	Provide site uid which will be use to move the device to.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,

        [Parameter(Mandatory=$True)] 
        $siteUid
    )
	
	# Validate device UID
	if($deviceUid.GetType().Name -ne 'String') {
		return 'The Device UID must be a String!'
	}
	elseif($deviceUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Device UID format is incorrect!'
	}


	# Validate Site UID
	if($siteUid.GetType().Name -ne 'String') {
		return 'The Site UID must be a String!'
	}
	elseif($siteUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Site UID format is incorrect!'
	}

	# Declare Variables
	$apiMethod = 'PUT'

	# Update UDFs
	New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/site/$siteUid"

}