function Get-DrmmAuditPrinter {

	<#
	.SYNOPSIS
	Fetches audit data of the generic device identified the given device Uid.

	.PARAMETER DeviceUid
	Provide device uid which will be used to get the Printer audit data
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
    )

    # Declare Variables
    $apiMethod = 'GET'
	
	# Return device audit
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/audit/printer/$deviceUid" | ConvertFrom-Json

}