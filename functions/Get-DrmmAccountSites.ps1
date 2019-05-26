function Get-DrmmAccountSites
{

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do 
    {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/sites?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response)
	    {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.sites
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all sites except the 'Deleted Devices' site
    return $Results | where name -ne 'Deleted Devices'

}