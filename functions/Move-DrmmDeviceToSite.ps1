function Move-DrmmDeviceToSite {

	<#
	.SYNOPSIS
	Moves a device from one site to another site.

	.PARAMETER deviceUid
	Provide device uid which of device you woul dlike to move.

	.PARAMETER siteUid
	Provide site uid which will be use to move the device to.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,

        [Parameter(Mandatory=$True)] 
        $siteUid
    )
	
	# Declare Variables
	$apiMethod = 'PUT'

	# Update UDFs
	New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/site/$siteUid"

}