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

	.PARAMETER ComponentName
	Provide name of the component to run.

	.PARAMETER Variables 
	Provide variables names and values, must be a hash.

	.EXAMPLE
    $response = Set-DrmmDeviceQuickJob -DeviceUid '00000000-0000-0000-0000-000000000000' -jobName "Quick Job running Foo" -ComponentName "Foo" -Variables @{"bar"="baz";"qux"="quux"}
	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,

        [Parameter(Mandatory=$True)] 
		$jobName,
		
		[Parameter(Mandatory=$True)] 
        $ComponentName,

        [Parameter(Mandatory=$False)] 
        [hashtable]$variables

    )
	
	# Declare Variables
	$apiMethod = 'PUT'
	$jobComponent = @{}
	$quickJobRequest = @{}

	# Get Component Uid
	ForEach ($Component in Get-DrmmAccountComponents)
	{
		if($Component.name -ieq $ComponentName)
		{ 
			$componentUid = $Component.uid
		}
	}

	if ( $null -eq $componentUid ) {
		throw "Could not find a component named `"$ComponentName`" specified by parameter 'ComponentName'"
	}

	#convert variable data from hashtable to array that can be converted to API-compatible JSON object
    $variablesArray = @()
    foreach ( $Key in $variables.Keys ) {
        $temp = @{
            "name" = $Key
            "value" = $variables[$Key]
        }
        $variablesArray += $temp
    }

	# Create quick job request
	$quickJobRequest.Add('jobName',$jobName)
	$jobComponent.Add('componentUid',$componentUid)
	$jobComponent.Add('variables',$variablesArray)
	$quickJobRequest.Add('jobComponent',$jobComponent)

	# Convert to JSON
	$Body = $quickJobRequest | ConvertTo-Json -Depth 3

	# Update UDFs
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/quickjob" -apiRequestBody $Body | ConvertFrom-Json

}