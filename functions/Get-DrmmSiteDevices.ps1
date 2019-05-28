function Get-DrmmSiteDevices
{

<#
.SYNOPSIS
Fetches the devices records of the site identified by the given site uid.

.DESCRIPTION
Returns device settings, device type, device anti-virus status, device patch Status and UDF's.

Device {
a64Bit (boolean, optional),
antivirus (Antivirus, optional),
cagVersion (string, optional),
creationDate (integer, optional),
deleted (boolean, optional),
description (string, optional),
deviceClass (string, optional) = ['device', 'printer', 'esxihost', 'unknown'],
deviceType (DevicesType, optional),
displayVersion (string, optional),
domain (string, optional),
extIpAddress (string, optional),
hostname (string, optional),
id (integer, optional),
intIpAddress (string, optional),
lastAuditDate (integer, optional),
lastLoggedInUser (string, optional),
lastReboot (integer, optional),
lastSeen (integer, optional),
online (boolean, optional),
operatingSystem (string, optional),
patchManagement (PatchManagement, optional),
portalUrl (string, optional),
rebootRequired (boolean, optional),
siteId (integer, optional),
siteName (string, optional),
siteUid (string, optional),
snmpEnabled (boolean, optional),
softwareStatus (string, optional),
suspended (boolean, optional),
udf (Udf, optional),
uid (string, optional),
warrantyDate (string, optional)
}
Antivirus {
antivirusProduct (string, optional),
antivirusStatus (string, optional) = ['RunningAndUpToDate', 'RunningAndNotUpToDate', 'NotRunning', 'NotDetected']
}
DevicesType {
category (string, optional),
type (string, optional)
}
PatchManagement {
patchStatus (string, optional) = ['NoPolicy', 'NoData', 'RebootRequired', 'InstallError', 'ApprovedPending', 'FullyPatched'],
patchesApprovedPending (integer, optional),
patchesInstalled (integer, optional),
patchesNotApproved (integer, optional)
}
Udf {
udf1 (string, optional),
udf10 (string, optional),
udf11 (string, optional),
udf12 (string, optional),
udf13 (string, optional),
udf14 (string, optional),
udf15 (string, optional),
udf16 (string, optional),
udf17 (string, optional),
udf18 (string, optional),
udf19 (string, optional),
udf2 (string, optional),
udf20 (string, optional),
udf21 (string, optional),
udf22 (string, optional),
udf23 (string, optional),
udf24 (string, optional),
udf25 (string, optional),
udf26 (string, optional),
udf27 (string, optional),
udf28 (string, optional),
udf29 (string, optional),
udf3 (string, optional),
udf30 (string, optional),
udf4 (string, optional),
udf5 (string, optional),
udf6 (string, optional),
udf7 (string, optional),
udf8 (string, optional),
udf9 (string, optional)
}

.PARAMMETER siteUid
Provide site uid wchih will be use to return this site devices.


#>
    # Function Parameters
    [CmdletBinding()] 
    Param (
        [Parameter(Mandatory=$True)] 
        $siteUid
    )
    
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do 
    {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/devices?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response)
	    {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.devices
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all site devices
    return $Results

}