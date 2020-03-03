function Set-DrmmDeviceQuickJob {

	<#
	.SYNOPSIS
	Creates a quick job on the device identified by the given device Uid.

	.DESCRIPTION
	Will run a quickjob on a given device and return the Job uid, name and variables used.

	.PARAMETER DeviceUid
	Provide device uid which will be used to run the quickjob.

	.PARAMETER JobName
	Provide name of the quick job.

	.PARAMETER Variables 
	Provide variables names and values, must be a hash.

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
	
	# Declare Variables
	$apiMethod = 'PUT'
	$jobComponent = @{}
	$quickJobRequest = @{}
	$componentUid = ''

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
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/quickjob" -apiRequestBody $Body | ConvertFrom-Json

}