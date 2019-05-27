function Get-DrmmAccountSites
{

<#
.SYNOPSIS
Fetches the site records of the authenticated user's account.

.DESCRIPTION
Returns Site Settings, Device Status and Proxy Settings.

.INPUTS

.OUTPUTS
Site {
autotaskCompanyId (string, optional),
autotaskCompanyName (string, optional),
description (string, optional),
devicesStatus (DevicesStatus, optional),
id (integer, optional),
name (string, optional),
notes (string, optional),
onDemand (boolean, optional),
portalUrl (string, optional),
proxySettings (ProxySettings, optional),
splashtopAutoInstall (boolean, optional),
uid (string, optional): Unique alphanumeric UID of this site ,
accountUid (string, optional): Unique alphanumeric UID of the account to which this site belongs
}
DevicesStatus {
numberOfDevices (integer, optional),
numberOfOfflineDevices (integer, optional),
numberOfOnlineDevices (integer, optional)
}
ProxySettings {
host (string, optional),
password (string, optional),
port (integer, optional),
type (string, optional) = ['http', 'socks4', 'socks5'],
username (string, optional)
}

#>

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do 
    {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/sites?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response)
	    {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.Site
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all sites except the 'Deleted Devices' site
    return $Results | where name -ne 'Deleted Devices'

}