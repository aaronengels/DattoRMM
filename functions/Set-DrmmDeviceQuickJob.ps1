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

	.PARAMETER ComponentUid
	Provide the uid of the component to run instead of its name. Skips downloading the account's
	component list to look the name up, and can't pick the wrong component when names are similar.
	The uid is shown by Get-DrmmAccountComponents.

	.PARAMETER Variables 
	Provide variables names and values, must be an array object (see examples)

	.PARAMETER VariableDefinitions 
	Provide variables names and values, must be a hashtable (see examples)

	.EXAMPLE
	$variables = @() + @{name = "variable1";value = "variable1Value"} + @{name="variable2";value='variable2Value'}
    $response = Set-DrmmDeviceQuickJob -DeviceUid '00000000-0000-0000-0000-000000000000' -jobName "Quick Job running Foo" -ComponentName "Foo" -Variables @{"bar"="baz";"qux"="quux"}
	
	.EXAMPLE
	$response = Set-DrmmDeviceQuickJob -DeviceUid '00000000-0000-0000-0000-000000000000' -jobName "Quick Job running Foo" -ComponentName "Foo" -VariableDefinitions @{"variable1"="variable1Value";"variable2"="variable2Value"}

	.EXAMPLE
	$job = Set-DrmmDeviceQuickJob -deviceUid $uid -jobName 'Diag' -ComponentUid '71c3b653-bb69-4e3e-aa0c-9b426d37830a'
	Wait-DrmmJob -jobUid $job.job.uid -deviceUid $uid -IncludeOutput
	Runs a component by uid and waits for its result and StdOut.
	#>

	# Function Parameters
	[CmdletBinding(DefaultParameterSetName='preparedVariables', SupportsShouldProcess = $True, ConfirmImpact = 'Medium')]
    Param (
        [Parameter(Mandatory=$True,ParameterSetName = "preparedVariables")]
        [Parameter(Mandatory=$True,ParameterSetName = "unpreparedVariables")]
        [Parameter(Mandatory=$True,ParameterSetName = "componentUid")]
        $deviceUid,

        [Parameter(Mandatory=$True,ParameterSetName = "preparedVariables")]
        [Parameter(Mandatory=$True,ParameterSetName = "unpreparedVariables")]
        [Parameter(Mandatory=$True,ParameterSetName = "componentUid")]
		$jobName,

		[Parameter(Mandatory=$True,ParameterSetName = "preparedVariables")]
        [Parameter(Mandatory=$True,ParameterSetName = "unpreparedVariables")]
        $ComponentName,

        [Parameter(Mandatory=$False,ParameterSetName = "preparedVariables")]
        [Parameter(Mandatory=$False,ParameterSetName = "componentUid")]
		[PSCustomObject]$variables,

		[Parameter(Mandatory=$False,ParameterSetName = "unpreparedVariables")]
        [Parameter(Mandatory=$False,ParameterSetName = "componentUid")]
        [hashtable]$VariableDefinitions,

        # Declared last so the existing parameters keep their positions
        [Parameter(Mandatory=$True,ParameterSetName = "componentUid")]
        [ValidateNotNullOrEmpty()]
        [string]$ComponentUid

    )

	# Declare Variables
	$apiMethod = 'PUT'
	$jobComponent = @{}
	$quickJobRequest = @{}

	if ( $PSBoundParameters.ContainsKey('variables') -and $PSBoundParameters.ContainsKey('VariableDefinitions') ) {
		throw "Set-DrmmDeviceQuickJob : supply either -variables or -VariableDefinitions, not both. No job was created."
	}

	# Resolve the component uid into its own variable: PowerShell variable names are case-insensitive,
	# so reusing $componentUid would write into the [string]-typed -ComponentUid parameter.
	$resolvedComponentUid = $null
	if ( $PSCmdlet.ParameterSetName -eq 'componentUid' ) {
		# Use the uid as given; the API rejects an unknown component
		$resolvedComponentUid = $ComponentUid
		$componentLabel = "component $ComponentUid"
	}
	else {
		# Get Component Uid
		ForEach ($Component in Get-DrmmAccountComponents)
		{
			if($Component.name -ieq $ComponentName)
			{
				$resolvedComponentUid = $Component.uid
			}
		}

		if ( $null -eq $resolvedComponentUid ) {
			throw "Could not find a component named `"$ComponentName`" specified by parameter 'ComponentName'"
		}
		$componentLabel = "component '$ComponentName'"
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
	$jobComponent.Add('componentUid',$resolvedComponentUid)
	$jobComponent.Add('variables',$variables)
	$quickJobRequest.Add('jobComponent',$jobComponent)

	# Convert to JSON - Increased depth is needed to convert variable definitions if present
	$Body = $quickJobRequest | ConvertTo-Json -Depth 3

	# Create QuickKob
	if (-not $PSCmdlet.ShouldProcess("device $deviceUid", "Run quick job '$jobName' ($componentLabel)")) { return }
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/quickjob" -apiRequestBody $Body | ConvertFrom-Json

}