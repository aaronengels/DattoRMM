function New-ApiRequest
{

<#
.SYNOPSIS
Makes a API request.

.DESCRIPTION
Returns the API response.

.PARAMETER apiMethod
Provide API Method GET, PUT or POST

.PARAMETER apiRequest 
See Datto RMM API swagger UI

.PARAMETER apiRequestBody 
Only used with PUT and POST request

.OUTPUTS
API response

#>
    [CmdletBinding()]
	Param(
        [Parameter(Mandatory=$True)]
        [ValidateSet('GET','PUT','POST')]
		[string]$apiMethod,

        [Parameter(Mandatory=$True)]
		[string]$apiRequest,
    
        [Parameter(Mandatory=$False)]
		[string]$apiRequestBody
	)

    #Get API Token
    $apiAccessToken = New-ApiAccessToken

	# Define parameters for Invoke-WebRequest cmdlet
	$params = [ordered] @{
		Uri         = '{0}/api{1}' -f $apiUrl, $apiRequest
		Method      = $apiMethod
		ContentType = 'application/json'
		Headers     = @{
			'Authorization' = 'Bearer {0}' -f $apiAccessToken
		}
	}

	# Add body to parameters if present
	If ($apiRequestBody) {$params.Add('Body',$apiRequestBody)}

	# Make request
	try {(Invoke-WebRequest @params).Content}
	catch {Write-Host $_.Exception.Message}
}