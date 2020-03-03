function Set-DrmmSiteProxy {

	<#
	.SYNOPSIS
	Updates the proxy settings for the site identified by the given site Uid.

	.PARAMETER SiteUid
	Provide site uid which will be used to update proxy settings.

	.PARAMETER ProxyHost
	Proxy host name (IP Address or URL).

	.PARAMETER ProxyPort
	Proxy port. 

	.PARAMETER ProxyType
	Proxy type (http, socks4, or socks5). 

	.PARAMETER ProxyUsername
	Proxy username.

	.PARAMETER ProxyPassword
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