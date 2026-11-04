function New-DrmmSite {

	<#
	.SYNOPSIS
	Creates a new site in the authenticated user's account.

	.PARAMETER SiteName
	Provide sitename.

	.PARAMETER SiteDescription
	Provice site description.

	.PARAMETER SiteNotes
	Provide site notes.
	
	.PARAMETER OnDemand
	Will mark site as a on demand site.

	.PARAMETER SplashtopAutoInstall
	Will switch on autoinstall spashtop.

	.PARAMETER ProxyHost
	Optional. Proxy host name (IP address or URL) for the new site. Requires -ProxyPort and -ProxyType.

	.PARAMETER ProxyPort
	Proxy port (1-65535).

	.PARAMETER ProxyType
	Proxy type: http, socks4 or socks5.

	.PARAMETER ProxyUsername
	Optional proxy username.

	.PARAMETER ProxyPassword
	Optional proxy password.

	.EXAMPLE
	New-DrmmSite -siteName 'Contoso' -proxyHost 'proxy.contoso.local' -proxyPort 8080 -proxyType http
	Creates the site with its proxy settings in one request (otherwise New-DrmmSite then Set-DrmmSiteProxy).

	#>

	# Function Parameters
	[CmdletBinding(SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory=$True)] 
        $siteName,

        [Parameter(Mandatory=$False)] 
        $siteDescription,

        [Parameter(Mandatory=$False)] 
        $siteNotes,

        [Parameter(Mandatory=$False)] 
        [switch]$onDemand,

        [Parameter(Mandatory=$False)]
        [switch]$splashtopAutoInstall,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [string]$proxyHost,

        [Parameter(Mandatory=$False)]
        [ValidateRange(1, 65535)]
        [int]$proxyPort,

        [Parameter(Mandatory=$False)]
        [ValidateSet('http','socks4','socks5')]
        [string]$proxyType,

        [Parameter(Mandatory=$False)]
        [string]$proxyUsername,

        [Parameter(Mandatory=$False)]
        [string]$proxyPassword
    )
	

	# Declare Variables
	$apiMethod = 'PUT'
	$createSiteRequest = @{}
	$Results = @()

	# Create site request
	$createSiteRequest.Add('name',$siteName)
	If ($PSBoundParameters.ContainsKey('siteDescription')) {$createSiteRequest.Add('description',$siteDescription)}
	If ($PSBoundParameters.ContainsKey('siteNotes')) {$createSiteRequest.Add('notes',$siteNotes)}
	If ($PSBoundParameters.ContainsKey('onDemand')) {$createSiteRequest.Add('onDemand',$True)}
	If ($PSBoundParameters.ContainsKey('splashtopAutoInstall')) {$createSiteRequest.Add('splashtopAutoInstall',$True)}

	# Optional proxy settings, sent with the create request
	$proxyParameters = @('proxyHost', 'proxyPort', 'proxyType', 'proxyUsername', 'proxyPassword') | Where-Object { $PSBoundParameters.ContainsKey($_) }
	If ($proxyParameters) {
		$missing = @('proxyHost', 'proxyPort', 'proxyType') | Where-Object { -not $PSBoundParameters.ContainsKey($_) }
		If ($missing) {
			throw "New-DrmmSite : proxy settings need -proxyHost, -proxyPort and -proxyType together; missing -$($missing -join ', -'). The site was not created."
		}
		$proxySettings = [ordered]@{ host = $proxyHost; port = $proxyPort; type = $proxyType }
		If ($PSBoundParameters.ContainsKey('proxyUsername')) {$proxySettings.Add('username',$proxyUsername)}
		If ($PSBoundParameters.ContainsKey('proxyPassword')) {$proxySettings.Add('password',$proxyPassword)}
		$createSiteRequest.Add('proxySettings',$proxySettings)
	}

	# Convert to JSON
	$Body = $createSiteRequest | ConvertTo-Json

	# Create Site and return results
	if (-not $PSCmdlet.ShouldProcess("site '$siteName'", 'Create site')) { return }
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}