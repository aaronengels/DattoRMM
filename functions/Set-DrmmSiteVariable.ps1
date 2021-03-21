function Set-DrmmSiteVariable {

    <#
	.SYNOPSIS
	Modifies the specified account variable by assigning the given name and value.
    .PARAMETER siteUid
    The UID of the site under which this variable exists.
    
    .PARAMETER variableId
    The ID of the variable to modify.
    
	.PARAMETER name
	The name of the variable.
    .PARAMETER value
    The value of the variable.
    	
	#>

    # Function Parameters
    Param (
        [Parameter(Mandatory = $True)] 
        $siteUid,
        [Parameter(Mandatory = $True)] 
        $variableId,
        [Parameter(Mandatory = $True)]
        $name,
        [Parameter(Mandatory = $True)]
        $value
    )

    # Declare Variables
    $apiMethod = 'POST'
    $createVariableRequest = @{}

    $createVariableRequest.Add('name', $name)
    $createVariableRequest.Add('value', $value)

    # Convert to JSON
    $Body = $createVariableRequest | ConvertTo-Json

    # Return Variable
    return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid/variable/$variableId" -apiRequestBody $Body | ConvertFrom-Json

} 