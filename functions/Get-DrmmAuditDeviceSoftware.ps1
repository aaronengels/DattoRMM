function Get-DrmmAuditDeviceSoftware {

	<#
	.SYNOPSIS
	Fetches audited software of the generic device identified the given device Uid.

	.PARAMETER siteUid
	Provide site uid which will be use to return this site devices.
	
	#>
    
	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid
    )

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 250
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/audit/$deviceUid/software?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response) {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.devices
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all sdevice software entries
    return $Results

}