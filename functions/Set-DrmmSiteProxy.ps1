function Set-DrmmSiteProxy {

	<#
	.SYNOPSIS
	Updates the proxy settings for the site identified by the given site Uid.

	.PARAMETER siteUid
	Provide site uid which will be used to update proxy settings.

	.PARAMETER proxyHost
	Proxy host name (IP Address or URL).

	.PARAMETER proxyPort
	Proxy port. 

	.PARAMETER proxyType
	Proxy type (http, socks4, or socks5). 

	.PARAMETER proxyUsername
	Proxy username.

	.PARAMETER proxyPassword
	Proxy password.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $siteUid,

        [Parameter(Mandatory=$True)] 
        $proxyHost,

        [Parameter(Mandatory=$True)] 
        $proxyPort,

	    [Parameter(Mandatory=$True)]
		[ValidateSet('http','socks4','socks5')]
        $proxyType,

        [Parameter(Mandatory=$False)] 
        $proxyUsername,

		[Parameter(Mandatory=$False)] 
        $proxyPassword

    )

	# Declare Variables
	$apiMethod = 'POST'
	$Results = @()
	$proxySettings = @{}
	
	# Add proxy details
	$proxySettings.Add('host',$proxyHost)
	$proxySettings.Add('port',$proxyPort)
	$proxySettings.Add('type',$proxyType)
	If ($PSBoundParameters.ContainsKey('proxyUsername')) {$proxySettings.Add('username',$proxyUsername)}
	If ($PSBoundParameters.ContainsKey('proxyPassword')) {$proxySettings.Add('password',$proxyPassword)}

	# Convert to JSON
	$Body = $proxySettings | ConvertTo-Json
	
	# API Request
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/settings/proxy" -apiRequestBody $Body | ConvertFrom-Json

}