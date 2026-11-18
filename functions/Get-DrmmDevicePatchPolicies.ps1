function Get-DrmmDevicePatchPolicies {

	<#
	.SYNOPSIS
	Fetches the patch management policies of the device identified by the given device Uid.

	.DESCRIPTION
	Returns each patch policy that applies to the device, grouped into schedule, power, approval and
	rebootBehavior sections, plus its owner, site and dates.
	Requires Datto RMM 15.2.0 or later; on earlier platform versions the endpoint returns 404 (not found).
	The API user needs the Sites: View, Policies: View and Devices: View permissions.

	.PARAMETER DeviceUid
	Provide device uid which will be used to return the device patch policies.

	.EXAMPLE
	Get-DrmmDevicePatchPolicies -deviceUid $uid | Select-Object policyName, enabled, schedule

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$True)]
		[ValidateNotNullOrEmpty()]
		[string]$deviceUid
	)

	$apiRequest = '/v2/device/{0}/policies/patch-management' -f [uri]::EscapeDataString($deviceUid)

	# Return all patch policies for the device
	return New-ApiPagedRequest -apiRequest $apiRequest -resultProperty 'policies'
}
