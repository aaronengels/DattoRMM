function Get-DrmmAccount {

	<#
	.SYNOPSIS
	Fetches the authenticated user's account data.

	.DESCRIPTION
	Returns account settings, descriptor and account device status.

	Account {
	currency (string, optional),
	descriptor (Account Descriptor, optional),
	devicesStatus (AccountDevicesStatus, optional),
	id (integer, optional),
	name (string, optional),
	uid (string, optional)
	}
	Account Descriptor {
	bilingEmail (string, optional),
	deviceLimit (integer, optional),
	timeZone (string, optional)
	}
	AccountDevicesStatus {
	numberOfDevices (integer, optional),
	numberOfManagedDevices (integer, optional),
	numberOfOfflineDevices (integer, optional),
	numberOfOnDemandDevices (integer, optional),
	numberOfOnlineDevices (integer, optional)
	}

	#>

    # Declare Variables
    $apiMethod = 'GET'
    $Results = @()
	
	# Return all account settings
	return $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/" | ConvertFrom-Json

}