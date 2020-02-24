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
	
	# Declare Variables
	$apiMethod = 'DELETE'
	$Results = @()

	# Update UDFs
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/setting/proxy" | ConvertFrom-Json
	return $Results

}