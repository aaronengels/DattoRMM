function Set-DrmmDeviceWarranty {

	<#
	.SYNOPSIS
	Sets a Datto RMM Device Warranty

	.DESCRIPTION
	
	Warranty {
	warrantyDate (string, optional)
	}

	.PARAMETER DeviceUid
	Provide device uid which will be used to set the warranty field 

	.PARAMETER Warranty
	Provide value for the warranty field

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory = $True)] 
		$deviceUid,

		[Parameter(Mandatory = $True)] 
		$warrantyDate
	)

	# Declare Variables
	$apiMethod = 'POST'
	$Warranty = @{}

	# Add Warranty if provided
	If ($PSBoundParameters.ContainsKey('warrantyDate')) { $Warranty.Add('warrantyDate', $warrantyDate) }

	# Convert to JSON
	$Body = $Warranty | ConvertTo-Json
	write-host $body
	# Update Warranty
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/warranty" -apiRequestBody $Body
}