function Set-DrmmAlertMute {

	<#
	.SYNOPSIS
	Mutes the alert identified by the given alert Uid.

	.DESCRIPTION
	Mute and alert providing the alert Uid.

	.PARAMETER alertUid
	Provide alert Uid to mute the alert.
	
	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $alertUid
    )
	
	# Declare Variables
		$apiMethod = 'POST'

	# Mute Alert
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/alert/$alertUid/mute"

}