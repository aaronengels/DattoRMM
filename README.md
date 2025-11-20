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

## Version 1.0.0.33
- Fixed clear Set-DrmmDeviceWarranty issue (by Jonathan Buller)
- Added Get-DrmmJobResults (by mbmy)

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





