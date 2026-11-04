function Get-DrmmDevicePatches {

	<#
	.SYNOPSIS
	Fetches the patches of the device identified by the given device Uid.

	.DESCRIPTION
	Returns full patch metadata for the device: title, KB article, category, severity, release date,
	size, reboot requirement and install status. Requires Datto RMM 15.1.0 or later.

	.PARAMETER DeviceUid
	Provide device uid which will be used to return the device patches.

	.PARAMETER InstallStatus
	Optionally return only patches with this install status: INSTALLED, APPROVED_PENDING or NOT_APPROVED.

	.EXAMPLE
	Get-DrmmDevicePatches -deviceUid $uid -InstallStatus APPROVED_PENDING

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$True)]
		[ValidateNotNullOrEmpty()]
		[string]$deviceUid,

		[Parameter(Mandatory=$False)]
		[ValidateSet('INSTALLED', 'APPROVED_PENDING', 'NOT_APPROVED')]
		[string]$InstallStatus
	)

	$apiRequest = '/v2/device/{0}/patches' -f [uri]::EscapeDataString($deviceUid)
	if ($InstallStatus) {
		$apiRequest += '?installStatus={0}' -f $InstallStatus.ToUpperInvariant()
	}

	# Return all device patches
	return New-ApiPagedRequest -apiRequest $apiRequest -resultProperty 'patches'
}
