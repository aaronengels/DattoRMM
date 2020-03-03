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
        [Parameter(Mandatory=$True)] 
        $deviceUid,

        [Parameter(Mandatory=$True)] 
        $warranty
    )

	# Declare Variables
		$apiMethod = 'POST'
		$Warranty = @{}

	# Add Wwrranty if provided
	If ($PSBoundParameters.ContainsKey('warranty')) {$Warranty.Add('warranty',$warranty)}

	# Convert to JSON
	$Body = $Warranty | ConvertTo-Json

	# Update Warranty
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/warranty" -apiRequestBody $Body
}