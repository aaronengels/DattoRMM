function Set-DrmmDeviceQuickJob {

	<#
	.SYNOPSIS
	Creates a quick job on the device identified by the given device Uid.

	.DESCRIPTION
	Will run a quickjob on a given device and return the Job uid, name and variables used.

	.PARAMETER deviceUid
	Provide device uid which will be used to run the quickjob.

	.PARAMETER jobName
	Provide name of the quick job.

	.PARAMETER variables 
	Provide variables names and values.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,

        [Parameter(Mandatory=$True)] 
        $jobName,

        [Parameter(Mandatory=$False)] 
        $variables

    )
	
	# Validate device UID
	if($deviceUid.GetType().Name -ne 'String') {
		return 'The Device UID is not a String!'
	}
	elseif($deviceUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Device UID format is incorrect!'
	}

	# Declare Variables
	$apiMethod = 'PUT'
	$jobComponent = @{}
	$quickJobRequest = @{}
	$componentUid = ''
	$Results = @()

	# Get Component Uid
	ForEach ($Component in Get-DrmmAccountComponents)
	{
		if($Component.name -eq $jobName)
		{ 
			$componentUid = $Component.uid
		}
	}

	# Create quick job request
	$quickJobRequest.Add('jobName',$jobName)
	$jobComponent.Add('componentUid',$componentUid)
	$jobComponent.Add('variables',$variables)
	$quickJobRequest.Add('jobComponent',$jobComponent)

	# Convert to JSON
	$Body = $quickJobRequest | ConvertTo-Json

	# Update UDFs
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/quickjob" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}