function New-ApiRequest
{
	Param(
		[string]$apiMethod,
		[string]$apiRequest,
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