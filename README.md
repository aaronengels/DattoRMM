# About

This module is designed to make it easier to use the Datto RMM API in your PowerShell scripts. As all the hard work is done,
you can develop your scripts faster and be more efficient. There is no need to go through a big learning curve spending lots
of time working out how to use the Datto RMM API. Simply load the module, enter your API keys and get results within minutes!

# Support my work
You can donate to continue support this project https://gofund.me/fb60f42d

# Basics

You can install the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/DattoRMM) and use example below to get started.

```powershell
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

How to create API keys goto https://help.aem.autotask.net/en/Content/2SETUP/APIv2.htm for more information.  
For the REST API properties goto https://merlot-api.centrastage.net/api/swagger-ui.html#/ for more information.

# Release notes

## Version 1.0.0.29
- Fixed umlaut problem (by BKSystemsEngler)

## Version 1.0.0.28
- Added -UseBasicParsing parameter to Invoke-WebRequest (by Rob Gilbreath)

## Version 1.0.0.26
- Fixed Get-DrmmAuditDeviceSoftware
- Update Get-DrmmAccountDevices.ps1 (by Rob Gilbreath)
- Update Get-DrmmSiteDevices.ps1 (by Rob Gilbreath)
- Create Get-DrmmCustomFilters.ps1 (by Rob Gilbreath)
- Create Get-DrmmDefaultFilters.ps1 (by Rob Gilbreath)
- Update Get-DrmmCustomFilters.ps1 (by Rob Gilbreath)
- Update Get-DrmmDefaultFilters.ps1 (by Rob Gilbreath)
- Update Get-DrmmCustomFilters.ps1 (by Rob Gilbreath)
- Update Get-DrmmDefaultFilters.ps1 (by Rob Gilbreath)
- Update Get-DrmmAccountDevices.ps1 (by Rob Gilbreath)
- Update Get-DrmmSiteDevices.ps1 (by Rob Gilbreath)

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
- Added Add-DrmmAlertMessage - Add a alert message based on the alert context provided by the API.
- Added Get-DrmmAuditESXi - To get audit data from ESXi hosts
- Added Get-DrmmAuditPrinter - To get audit data from printers
- Updated Get-DrmmAuditDeviceSoftware - Fixed API Request Url.
- Updated Set-DrmmDeviceUdf - Fixed API Request Url.
- Updated Set-DrmmSiteProxy - Fixed JSON request issue.
- Updated Remove-DrmmSiteProxy - Fixed JSON request issue.
- Updated Set-DrmmSiteProxy - Updated function parameters.
- Updated New-DrmmSite - Fixed issue when using onDemand switch.
- Updated Set-DrmmSite - Fixed issue when using onDemand switch.
- Updated New-ApiAccessToken - Adjusted security protocols

## Version 1.0.0.10
- Added Get-DrmmAuditDevice
- Added Get-DrmmAuditDeviceSoftware
- Updated New-ApiRequest - Added error handeling.
- Updated New-ApiAccessToken - Added error handeling.
- Updated New-ApiRequest - Removed global variables.
- Updated New-ApiRequest - Added delay when 600 request/minute reached.
- Updated Set-DrmmSiteProxy - Made host,port and type mandatory. 

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





