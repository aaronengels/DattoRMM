function Remove-DrmmSiteVariable {

    <#
	.SYNOPSIS
	Removes a site variable with the given variableId under the site with the given site UID.
    .PARAMETER siteUid
    The UID of the site under which the variable exists.
    
	.PARAMETER variableId
	The name of the variable.
	
	#>

    # Function Parameters
    Param (
        [Parameter(Mandatory = $True)] 
        $siteUid,

        [Parameter(Mandatory = $True)] 
        $variableId
    )

    # Declare Variables
    $apiMethod = 'DELETE'

    # Return Variable
    return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/variable/$variableId" | ConvertFrom-Json

} 