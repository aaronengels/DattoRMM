function Remove-DrmmSiteProxy {

	<#
	.SYNOPSIS
	Deletes site proxy settings for the site identified by the given site Uid.

	.PARAMETER siteUid
	Provide site uid which will be used to update proxy settings.

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
	$apiMethod = 'DELETE'
	$Results = @()

	# Update UDFs
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/setting/proxy" | ConvertFrom-Json
	return $Results

}