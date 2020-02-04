function Set-DrmmSiteProxy {

	<#
	.SYNOPSIS
	Creates/updates the proxy settings for the site identified by the given site Uid.

	.PARAMETER siteUid
	Provide site uid which will be used to update proxy settings.

	.PARAMETER proxySettings
	Provide proxysettings:	 
		 host(string,optional)
		 password(string,optional)
		 port(string,optional)
		 type(string,optional)=['http','socks4','socks5']
		 username(string,optional)
	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $siteUid,

        [Parameter(Mandatory=$False)] 
        $proxySettings

    )
	
	# Validate Site UID
	if($siteUid.GetType().Name -ne 'String') {
		return 'The Site UID is not a String!'
	}
	elseif($siteUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Site UID format is incorrect!'
	}

	# Declare Variables
	$apiMethod = 'PUT'
	$Results = @()

	# Convert to JSON
	$Body = $proxySettings| ConvertTo-Json


	# Update UDFs
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/setting/proxy" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}