function Get-DrmmDevice {

	<#
	.SYNOPSIS
	Fetches data of the device identified by the given device Uid, device Id or MAC address.

	.DESCRIPTION
	Returns device settings, device type, device anti-virus status, device patch Status and UDF's.

	.PARAMETER DeviceUid
	Provide device uid which will be used to return device data.

	.PARAMETER DeviceId
	Provide the numeric device id (the id property of a device) instead of the uid.

	.PARAMETER MacAddress
	Provide a MAC address instead of the uid. Separators are optional: 001A2B3C4D5E,
	00:1A:2B:3C:4D:5E, 00-1A-2B-3C-4D-5E and 001A.2B3C.4D5E are all accepted.
	Returns every device with a network interface using that MAC address, so more than one device
	can be returned.

	.EXAMPLE
	Get-DrmmDevice -deviceUid $uid

	.EXAMPLE
	Get-DrmmDevice -DeviceId 1234567

	.EXAMPLE
	Get-DrmmDevice -MacAddress '00:1A:2B:3C:4D:5E'

	#>

	# Function Parameters
	[CmdletBinding(DefaultParameterSetName = 'Uid')]
	Param (
		[Parameter(Mandatory=$True, Position=0, ParameterSetName='Uid')]
		$deviceUid,

		[Parameter(Mandatory=$True, ParameterSetName='Id')]
		[long]$DeviceId,

		[Parameter(Mandatory=$True, ParameterSetName='MacAddress')]
		[ValidateNotNullOrEmpty()]
		[string]$MacAddress
	)

	# Declare Variables
	$apiMethod = 'GET'

	switch ($PSCmdlet.ParameterSetName) {
		'Id' {
			$apiRequest = "/v2/device/id/$DeviceId"
		}
		'MacAddress' {
			$apiRequest = '/v2/device/macAddress/{0}' -f (ConvertTo-DrmmMacAddress -MacAddress $MacAddress)
		}
		default {
			$apiRequest = "/v2/device/$deviceUid"
		}
	}

	# Return device data
	return New-ApiRequest -apiMethod $apiMethod -apiRequest $apiRequest | ConvertFrom-Json

}
