# About

This module will make using the Datto RMM API in your PowerShell scripts easier. As all the hard work is done,
you can develop your scripts faster and be more efficient. There is no need to go through a big learning curve spending lots
of time working out how to use the Datto RMM API. Load the module, enter your API keys and get results within minutes!

# Basics

You can install the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/DattoRMM) and use the example below to get started.

```PowerShell
# Load module
Import-Module DattoRMM -Force

# Provide API Parameters
$params = @{
    Url        =  '<Datto RMM API Url>'
    Key        =  '<Datto RMM API Key>'
    SecretKey  =  '<Datto RMM API Secret Key>'
}

# Set API Parameters
Set-DrmmApiParameters @params

# Get Devices Patch Status
ForEach ($site in Get-DrmmAccountSites -noDeletedDevices)
{
    Foreach ($device in Get-DrmmSiteDevices $site.uid)
    {
        $device.hostname + " = " + $device.patchManagement.patchStatus
    }
}

```

# Datto RMM API

To learn how to create API keys, go to https://help.aem.autotask.net/en/Content/2SETUP/APIv2.htm.  
For more information on the REST API properties, go to https://merlot-api.centrastage.net/api/swagger-ui.html#/.

# Release notes

## Unreleased
- Updated New-ApiRequest - Handles errors by HTTP status code, so the 429/504 retries, the 403 wait and the 404 message now work on PowerShell 7 as well as Windows PowerShell 5.1. Other errors are reported with the same message on both (by Kyle Elliott)
- Updated Set-DrmmDeviceUdf - New -Udf parameter sets any of the 300 UDFs, e.g. `-Udf @{ 5 = 'value'; 120 = 'value' }`. The -udf1 to -udf30 parameters still work as before but are planned for deprecation; new scripts should use -Udf (by Kyle Elliott)
- Added Get-DrmmSiteFilters (by Kyle Elliott)
- Added Get-DrmmAccountDnetSiteMappings (by Kyle Elliott)
- Added Update-DrmmSite - Changes only the site settings supplied. Set-DrmmSite resets any setting it is not given (by Kyle Elliott)
- Added New-ApiPagedRequest - Shared helper that follows nextPageUrl for paged GET endpoints (by Kyle Elliott)
- Updated Get-DrmmAccountSites - Added -SiteName filter (by Kyle Elliott)
- Updated New-DrmmSite - Added optional proxy settings and -WhatIf/-Confirm (by Kyle Elliott)
- Updated Set-DrmmSite, Set-DrmmSiteProxy and Remove-DrmmSiteProxy - Added -WhatIf/-Confirm (by Kyle Elliott)
- Added ConvertTo-DrmmMacAddress - Normalizes a MAC address to the 12 hex digits the API expects (by Kyle Elliott)
- Updated Get-DrmmDevice - Look up a device by -DeviceId or -MacAddress as well as by uid (by Kyle Elliott)
- Updated Get-DrmmAuditDevice - Look up a device audit by -MacAddress (by Kyle Elliott)
- Updated Get-DrmmAccountDevices - Added -Hostname, -DeviceType, -OperatingSystem and -SiteName filters (by Kyle Elliott)
- Added Get-DrmmDevicePatches (by Kyle Elliott)
- Added Get-DrmmSitePatches (by Kyle Elliott)
- Added Get-DrmmDevicePatchPolicies (by Kyle Elliott)
- Added Get-DrmmJobComponents (by Kyle Elliott)
- Added Wait-DrmmJob - Waits for a job to finish and returns its result, optionally with StdOut/StdErr (by Kyle Elliott)
- Updated Set-DrmmDeviceQuickJob - Added -ComponentUid and -WhatIf/-Confirm (by Kyle Elliott)
- Added Get-DrmmSystemStatus (by Kyle Elliott)
- Added Get-DrmmSystemRequestRate (by Kyle Elliott)
- Added Get-DrmmSystemPagination (by Kyle Elliott)
- Updated Get-DrmmActivityLogs - Added -SearchQuery and fixed nextPageUrl parsing (by Kyle Elliott)

## Version 1.0.0.34
- Fixed clear Set-DrmmDeviceWarranty issue (by Jonathan Buller)
- Added Get-DrmmJobResults (by Michael Young)

## Version 1.0.0.32
- Added support to pull activity logs (by Phill Holbrook)
- Added PSCredential support for connecting Api (by Meelis Nigols)

## Version 1.0.0.31
- Added Get-DevicesNeedingReboot (by Brian Killay)
- Improved error handling (by Phill Holbrook)

## Version 1.0.0.29
- Fixed umlaut problem (by BKSystemsEngler)

## Version 1.0.0.28
- Added -UseBasicParsing parameter to Invoke-WebRequest (by Rob Gilbreath)

## Version 1.0.0.26
- Fixed Get-DrmmAuditDeviceSoftware
- Updated Get-DrmmAccountDevices.ps1 (by Rob Gilbreath)
- Updated Get-DrmmSiteDevices.ps1 (by Rob Gilbreath)
- Created Get-DrmmCustomFilters.ps1 (by Rob Gilbreath)
- Created Get-DrmmDefaultFilters.ps1 (by Rob Gilbreath)
- Updated Get-DrmmCustomFilters.ps1 (by Rob Gilbreath)
- Updated Get-DrmmDefaultFilters.ps1 (by Rob Gilbreath)
- Updated Get-DrmmCustomFilters.ps1 (by Rob Gilbreath)
- Updated Get-DrmmDefaultFilters.ps1 (by Rob Gilbreath)
- Updated Get-DrmmAccountDevices.ps1 (by Rob Gilbreath)
- Updated Get-DrmmSiteDevices.ps1 (by Rob Gilbreath)

## Version 1.0.0.25
- Added Get-DrmmSiteVariables (by Rob Gilbreath)
- Added Get-DrmmAccountVariables (by Rob Gilbreath)
- Added New-DrmmSiteVariables (by Rob Gilbreath)
- Added New-DrmmAccountVariables (by Rob Gilbreath)
- Added Remove-DrmmSiteVariables (by Rob Gilbreath)
- Added Remove-DrmmAccountVariables (by Rob Gilbreath)
- Added Set-DrmmDeviceWarranty (by Kelvin Tegelaar)
- Performance improvements, code cleanup, added features for v9.2  (by Kelvin Tegelaar)

## Version 1.0.0.22
- Added Set-DrmmApiParameters - You can now import the module first and add API parameters later.
- Added Add-DrmmAlertMessage - Add an alert message based on the alert context provided by the API.
- Added Get-DrmmAuditESXi - To get audit data from ESXi hosts
- Added Get-DrmmAuditPrinter - To get audit data from printers
- Updated Get-DrmmAuditDeviceSoftware - Fixed API Request URL.
- Updated Set-DrmmDeviceUdf - Fixed API Request URL.
- Updated Set-DrmmSiteProxy - Fixed JSON request issue.
- Updated Remove-DrmmSiteProxy - Fixed JSON request issue.
- Updated Set-DrmmSiteProxy - Updated function parameters.
- Updated New-DrmmSite - Fixed issue when using the onDemand switch.
- Updated Set-DrmmSite - Fixed issue when using the onDemand switch.
- Updated New-ApiAccessToken - Adjusted security protocols

## Version 1.0.0.10
- Added Get-DrmmAuditDevice
- Added Get-DrmmAuditDeviceSoftware
- Updated New-ApiRequest - Added error handling.
- Updated New-ApiAccessToken - Added error handling.
- Updated New-ApiRequest - Removed global variables.
- Updated New-ApiRequest - Added delay when 600 requests/minute reached.
- Updated Set-DrmmSiteProxy - Made host, port and type mandatory. 

## Version 1.0.0.8
- Added New-DrmmSite
- Added Set-DrmmSite
- Added Set-DrmmSiteProxy
- Added Set-DrmmSiteResolvedAlerts
- Added Set-DrmmSiteOpenAlerts
- Added Get-DrmmSiteSettings
- Added Get-DrmmDeviceResolvesAlerts
- Added Get-DrmmDeviceOpenAlerts
- Added Get-DrmmDeviceQuickJob
- Added Get-DrmmJobStatus
- Added Move-DrmmDeviceToSite
- Added Remove-DrmmSiteProxy

## Version 1.0.0.7
- Added Get-DrmmAlert Function
- Added Set-DrmmAlertMute Function
- Added Set-DrmmAlertResolve Function
- Added Set-DrmmAlertUnmute Function
- Added Set-DrmmDeviceUdf Function
- Added Set-DrmmDeviceWarranty Function

## Version 1.0.0.6

- Added -NoDeletedDevices Parameter to Get-DrmmSiteDevices to ignore the 'Deleted Devices' site.
- Added Get-DrmmAccount Function
- Added Get-DrmmAccountAlertsOpen Function
- Added Get-DrmmAccountAlertsResolved Function
- Added Get-DrmmAccountComponents Function
- Added Get-DrmmAccountDevices Function 
- Added Get-DrmmAccountUsers Function

## Version 1.0.0.5
- Added Get-DrmmSiteDevices Function
- Added Get-DrmmAccountSites Function
- Added New-ApiRequest Function
- Added New-ApiAccessToken Function





