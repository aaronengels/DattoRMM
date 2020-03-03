function Get-DrmmJobStatus {

	<#
	.SYNOPSIS
	Fetches data of the job identified by the given job Uid.

	.DESCRIPTION
	Returns job and including the status. Can be used to see the job status when running a quickjob using the API. 

	.PARAMETER JobUid
	Provide job uid which will be used to return job data.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $jobUid
    )
	
    # Declare Variables
    $apiMethod = 'GET'
    
	# Return device data
    return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/job/$jobUid" | ConvertFrom-Json
}