# Basics

Install the module from PowerShell Gallery and enter your API keys:

```powershell
# Download and install the module
Install-Module DattoRMM

# Enter API Url and API keys
$apiUrl         	=	'<Datto RMM API Url>'
$apiKey         	=	'<Datto RMM API Key>'
$apiSecretKey   	=	'<Datto RMM API Secret Key>'

# Load DattoRMM Module
Import-Module DattoRMM -ArgumentList $apiUrl, $apiKey, $apiSecretKey 

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

- Added Get-DrmmAccountSites Function
- Added Get-DrmmSiteDevices Function
- Added New-ApiRequest Function
- Added New-ApiAccessToken Function





