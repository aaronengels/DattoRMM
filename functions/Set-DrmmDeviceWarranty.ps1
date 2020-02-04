function Set-DrmmDeviceUdf {

	<#
	.SYNOPSIS
	Sets a Datto RMM Device Warranty

	.DESCRIPTION
	
	Warranty {
	warrantyDate (string, optional)
	}

	.PARAMMETER deviceUid
	Provide device uid which will be used to set the warranty field 

	.PARAMETER warranty
	Provide value for the warranty field

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,

        [Parameter(Mandatory=$True)] 
        $warranty
    )
	
	# Validate device UID
	if($deviceUid.GetType().Name -ne 'String') {
		return 'The Device UID is not a String!'
	}
	elseif($deviceUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Device UID format is incorrect!'
	}

	# Declare Variables
		$apiMethod = 'POST'
		$Warranty = @{}

	# Add Wwrranty if provided
	If ($PSBoundParameters.ContainsKey('warranty')) {$Warranty.Add('warranty',$warranty)}

	# Convert to JSON
	$Body = $Warranty | ConvertTo-Json

	# Update UDFs
	New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/warranty" -apiRequestBody $Body
}