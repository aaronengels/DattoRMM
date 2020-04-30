# About

This module is created to make it easier to use the DattoRMM API in your PowerShell scripts. As all the hard work is done,
you can develop your scripts faster. There is no need to go through a big learning curve spending lots of time working out 
how to use the Datto RMM API. Simply load the module, enter your API keys and get results within minutes!

# Basics

Install the module from PowerShell Gallery and enter your API keys:

```powershell
# Download and silently install the module
Install-Module DattoRMM -Force

# Enter API Url and API keys
$apiUrl        =  '<Datto RMM API Url>'
$apiKey        =  '<Datto RMM API Key>'
$apiSecretKey  =  '<Datto RMM API Secret Key>'

# Load DattoRMM Module
Import-Module DattoRMM -Force

# Set API Parameters
Set-DrmmApiParameters -Url $apiUrl -Key $apiKey -SecretKey $apiSecretKey

# Get Devices Patch Status
ForEach ($Site in Get-DrmmAccountSites -noDeletedDevices)
{
    Foreach ($Device in Get-DrmmSiteDevices $Site.uid)
    {
        $Device.hostname + " = " + $Device.patchManagement.patchStatus
    }
}

```

# Datto RMM API

How to create API keys goto https://help.aem.autotask.net/en/Content/2SETUP/APIv2.htm for more information.  
For the REST API properties goto https://merlot-api.centrastage.net/api/swagger-ui.html#/ for more information.

# Release notes

## Version 1.0.0.19
- Added Set-DrmmApiParameters - You can now import the module first and add API parameters later.
- Updated Get-DrmmAuditDeviceSoftware - Fixed API Request Url.
- Updated Set-DrmmDeviceUdf - Fixed API Request Url.
- Updated Set-DrmmSiteProxy - Fixed JSON request issue.
- Updated Remove-DrmmSiteProxy - Fixed JSON request issue.
- Updated Set-DrmmSiteProxy - Updated function parameters.
- Updated New-DrmmSite - Fixed issue when using onDemand switch.
- Updated Set-DrmmSite - Fixed issue when using onDemand switch.
- Updated Get-ApiAccessToken - Adjusted security protocols

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





