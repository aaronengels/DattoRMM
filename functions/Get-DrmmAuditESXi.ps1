function Get-DrmmAuditESXi {

	<#
	.SYNOPSIS
	Fetches audit data of the generic device identified the given device Uid.

	.PARAMETER DeviceUid
	Provide device uid which will be used to get the ESXi audit data
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
    )

    # Declare Variables
    $apiMethod = 'GET'
	
	# Return device audit
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/audit/esxihost/$deviceUid" | ConvertFrom-Json

}