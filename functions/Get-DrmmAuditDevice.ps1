function Get-DrmmAuditDevice {

	<#
	.SYNOPSIS
	Fetches audit data of the generic device identified the given device Uid or MAC address.

	.DESCRIPTION
	Returns the device audit: system info, network interfaces, BIOS, baseboard, displays, logical
	disks, processors, video boards, attached devices, physical memory and, on Datto RMM 15.2.0 or
	later, Windows OS info (osInfo).

	.PARAMETER DeviceUid
	Provide device uid which will be used to get the device audit

	.PARAMETER MacAddress
	Provide a MAC address instead of the uid. Separators are optional: 001A2B3C4D5E,
	00:1A:2B:3C:4D:5E, 00-1A-2B-3C-4D-5E and 001A.2B3C.4D5E are all accepted.
	Returns the audit of every device with a network interface using that MAC address.

	.EXAMPLE
	Get-DrmmAuditDevice -deviceUid $uid

	.EXAMPLE
	Get-DrmmAuditDevice -MacAddress '00-1A-2B-3C-4D-5E'

	#>

	# Function Parameters
	[CmdletBinding(DefaultParameterSetName = 'Uid')]
	Param (
		[Parameter(Mandatory=$True, Position=0, ParameterSetName='Uid')]
		$deviceUid,

		[Parameter(Mandatory=$True, ParameterSetName='MacAddress')]
		[ValidateNotNullOrEmpty()]
		[string]$MacAddress
	)

	# Declare Variables
	$apiMethod = 'GET'

	if ($PSCmdlet.ParameterSetName -eq 'MacAddress') {
		$apiRequest = '/v2/audit/device/macAddress/{0}' -f (ConvertTo-DrmmMacAddress -MacAddress $MacAddress)
	}
	else {
		$apiRequest = "/v2/audit/device/$deviceUid"
	}

	# Return device audit
	return New-ApiRequest -apiMethod $apiMethod -apiRequest $apiRequest | ConvertFrom-Json

}
