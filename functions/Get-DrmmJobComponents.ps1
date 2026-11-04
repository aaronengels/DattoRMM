function Get-DrmmJobComponents {

	<#
	.SYNOPSIS
	Fetches the components of the job identified by the given job Uid.

	.DESCRIPTION
	Returns each component in the job with its uid, name and variables.
	Combine with Get-DrmmJobStatus and Get-DrmmJobResults to inspect a job.

	.PARAMETER JobUid
	Provide job uid which will be used to return the job components.

	.EXAMPLE
	Get-DrmmJobComponents -jobUid $jobUid | Select-Object name, variables

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$True)]
		[ValidateNotNullOrEmpty()]
		[string]$jobUid
	)

	$apiRequest = '/v2/job/{0}/components' -f [uri]::EscapeDataString($jobUid)

	# Return all job components
	return New-ApiPagedRequest -apiRequest $apiRequest -resultProperty 'jobComponents'
}
