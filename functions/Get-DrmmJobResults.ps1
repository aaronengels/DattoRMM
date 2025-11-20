function Get-DrmmJobResults {

	<#
	.SYNOPSIS
	Fetches results of the job identified by the given job Uid.

	.DESCRIPTION
	Returns job results including stdout or stderr.

	.PARAMETER jobUid
	Provide job Uid which will be used to return job results.

	.PARAMETER deviceUid
	Provide device Uid which will be used to return job results.

	.PARAMETER resultType
	Optionally return either StdOut job result data or StdErr job result data instead of basic job results data.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $jobUid,
		[Parameter(Mandatory=$True)] 
        $deviceUid,
		[Parameter(Mandatory=$False)] 
		[ValidateSet("StdOut", "StdErr")] 
        [string]$resultType
    )
	
    # Declare Variables
    $apiMethod = 'GET'
    
	# Return job result data
	if ($ResultType -eq "StdOut") {
		return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/job/$jobUid/results/$deviceUid/stdout" | ConvertFrom-Json
	}
	elseif ($ResultType -eq "StdErr") {
		return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/job/$jobUid/results/$deviceUid/stderr" | ConvertFrom-Json
	}
    else {
		return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/job/$jobUid/results/$deviceUid" | ConvertFrom-Json
	}
}