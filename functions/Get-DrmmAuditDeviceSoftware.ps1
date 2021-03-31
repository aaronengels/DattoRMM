function Get-DrmmAuditDeviceSoftware {

	<#
	.SYNOPSIS
	Fetches audited software of the generic device identified the given device Uid.

	.PARAMETER deviceUid
	Provide site uid which will be used to return this site's audited software.
	
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

   $results = do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/audit/device/$deviceUid/software?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response) {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		$Response.software
		    $page++
	    }
    }
    until ($null -eq $nextPageUrl)

    # Return all sdevice software entries
    return $Results

}
