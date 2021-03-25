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
	Provide variables names and values, must be an array object (see examples)

	.PARAMETER VariableDefinitions 
	Provide variables names and values, must be a hashtable (see examples)

	.EXAMPLE
	$variables = @() + @{name = "variable1";value = "variable1Value"} + @{name="variable2";value='variable2Value'}
    $response = Set-DrmmDeviceQuickJob -DeviceUid '00000000-0000-0000-0000-000000000000' -jobName "Quick Job running Foo" -ComponentName "Foo" -Variables @{"bar"="baz";"qux"="quux"}
	
	.EXAMPLE
	$response = Set-DrmmDeviceQuickJob -DeviceUid '00000000-0000-0000-0000-000000000000' -jobName "Quick Job running Foo" -ComponentName "Foo" -VariableDefinitions @{"variable1"="variable1Value";"variable2"="variable2Value"}
	#>

	# Function Parameters
	[CmdletBinding(DefaultParameterSetName='preparedVariables')]
    Param (
        [Parameter(Mandatory=$True,ParameterSetName = "preparedVariables")] 
        [Parameter(Mandatory=$True,ParameterSetName = "unpreparedVariables")] 
        $deviceUid,

        [Parameter(Mandatory=$True,ParameterSetName = "preparedVariables")] 
        [Parameter(Mandatory=$True,ParameterSetName = "unpreparedVariables")] 
		$jobName,
		
		[Parameter(Mandatory=$True,ParameterSetName = "preparedVariables")] 
        [Parameter(Mandatory=$True,ParameterSetName = "unpreparedVariables")] 
        $ComponentName,

        [Parameter(Mandatory=$False,ParameterSetName = "preparedVariables")] 
		[PSCustomObject]$variables,
		
		[Parameter(Mandatory=$False,ParameterSetName = "unpreparedVariables")] 
        [hashtable]$VariableDefinitions

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

	if ( $PSBoundParameters.ContainsKey('VariableDefinitions') ) {
		#convert variable data from hashtable to array that can be converted to API-compatible JSON object
		$variables = @()
		foreach ( $Key in $VariableDefinitions.Keys ) {
			$temp = @{
				"name" = $Key
				"value" = $VariableDefinitions[$Key]
			}
			$variables += $temp
		}	
	}
	
	# Create quick job request
	$quickJobRequest.Add('jobName',$jobName)
	$jobComponent.Add('componentUid',$componentUid)
	$jobComponent.Add('variables',$variables)
	$quickJobRequest.Add('jobComponent',$jobComponent)

	# Convert to JSON - Increased depth is needed to convert variable definitions if present
	$Body = $quickJobRequest | ConvertTo-Json -Depth 3

	# Create QuickKob
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/quickjob" -apiRequestBody $Body | ConvertFrom-Json

}