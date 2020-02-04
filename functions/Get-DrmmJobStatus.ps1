function Get-DrmmJobStatus {

	<#
	.SYNOPSIS
	Fetches data of the job identified by the given job Uid.

	.DESCRIPTION
	Returns job and including the status. Can be used to see the job status when running a quickjob using the API. 

	.PARAMMETER jobUid
	Provide job uid which will be used to return job data.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $jobUid
    )
	
	# Validate device UID
	if($jobUid.GetType().Name -ne 'String') {
		return 'The Job UID is not a String!'
	}
	elseif($jobUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Job UID format is incorrect!'
	}
	
    # Declare Variables
    $apiMethod = 'GET'
    
	# Return device data
    $Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/job/$jobUid" | ConvertFrom-Json
	return $Results

}