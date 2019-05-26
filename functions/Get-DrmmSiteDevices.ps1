function Get-DrmmSiteDevices
{
    # Function Parameters
    [CmdletBinding()] Param ([Parameter(Mandatory=$True)] $siteId)
    
    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do 
    {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteId/devices?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response)
	    {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.devices
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all site devices
    return $Results

}