function Remove-DrmmAccountVariable {

    <#
	.SYNOPSIS
	Removes an account variable with the given variableId.
	.PARAMETER variableId
	The name of the variable.
	
	#>

    # Function Parameters
    Param (
        [Parameter(Mandatory = $True)] 
        $variableId
    )

    # Declare Variables
    $apiMethod = 'DELETE'

    # Return Variable
    return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/variable/$variableId" | ConvertFrom-Json

} 