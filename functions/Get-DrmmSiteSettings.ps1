function Get-DrmmSiteSettings {

	<#
	.SYNOPSIS
	Fetches data of the site (including total number of devices) identified by the given site Uid.

	.PARAMMETER siteUid
	Provide site uid which will be used to return device data.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $siteUid
    )
	
	# Validate device UID
	if($siteUid.GetType().Name -ne 'String') {
		return 'The Site UID is not a String!'
	}
	elseif($siteUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Site UID format is incorrect!'
	}
	
    # Declare Variables
    $apiMethod = 'GET'
    
	# Return device data
    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/settings" | ConvertFrom-Json
	return $Response

}