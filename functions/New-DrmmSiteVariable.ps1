function New-DrmmSiteVariable {

    <#
	.SYNOPSIS
	Creates a new site variable with the given name and value for the given site. The value can optionally be masked.
    .PARAMETER siteUid
    The UID of the site under which this variable should be placed.
    
	.PARAMETER name
	The name of the variable.
    .PARAMETER value
	The value of the variable.
    .PARAMETER masked
	Switch to set whether the value should be masked.
	
	#>

    # Function Parameters
    Param (
        [Parameter(Mandatory = $True)] 
        $siteUid,
        [Parameter(Mandatory = $True)] 
        $name,
        [Parameter(Mandatory = $True)] 
        $value,
        [Parameter(Mandatory = $false)]
        [Switch]
        $masked
    )

    # Declare Variables
    $apiMethod = 'PUT'
    $createVariableRequest = @{}

    $createVariableRequest.Add('name', $name)
    $createVariableRequest.Add('value', $value)
    If ( $masked -eq $true ) {
        $createVariableRequest.Add('masked', $true)
    }
    Else {
        $createVariableRequest.Add('masked', $false)
    }

    # Convert to JSON
    $Body = $createVariableRequest | ConvertTo-Json

    # Return Variable
    return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/variable" -apiRequestBody $Body | ConvertFrom-Json

} 