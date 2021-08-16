function New-ApiRequest {

	<#
	.SYNOPSIS
	Makes a API request.

	.DESCRIPTION
	Returns the API response.

	.PARAMETER ApiMethod
	Provide API Method GET, PUT or POST

	.PARAMETER ApiRequest 
	See Datto RMM API swagger UI

	.PARAMETER ApiRequestBody 
	Only used with PUT and POST request

    .INPUTS
	$apiUrl = The API URL
	$apiKey = The API Key
	$apiKeySecret = The API Secret Key

	.OUTPUTS
	API response

	#>
    
	Param(
		[Parameter(Mandatory = $True)]
		[ValidateSet('GET', 'PUT', 'POST', 'DELETE')]
		[string]$apiMethod,

		[Parameter(Mandatory = $True)]
		[string]$apiRequest,
    
		[Parameter(Mandatory = $False)]
		[string]$apiRequestBody
	)

	# Check API Parameters
	if (!$apiUrl -or !$apiKey -or !$apiSecretKey) {
		Write-Host "API Parameters missing, please run Set-DrmmApiParameters first!"
		return
	}

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
	If ($apiRequestBody) { $params.Add('Body', $apiRequestBody) }

	# Make request
	try {
		(Invoke-WebRequest -UseBasicParsing @params).Content
	}
	catch {
		
		$exceptionError = $_.Exception.Message
		
		switch ($exceptionError) {
	
			'The remote server returned an error: (429).' {
				Write-Host 'New-ApiRequest : API rate limit breached, sleeping for 60 seconds'
				Start-Sleep -Seconds 60
			}

			'The remote server returned an error: (403) Forbidden.' {
				Write-Host 'New-ApiRequest : AWS DDOS protection breached, sleeping for 5 minutes'
				Start-Sleep -Seconds 300
			}

			'The remote server returned an error: (404) Not Found.' {
				Write-Host "New-ApiRequest : $apiRequest not found!"
			}

			'The remote server returned an error: (504) Gateway Timeout.' {
				Write-Host "New-ApiRequest :  Gateway Timeout, sleeping for 60 seconds"
				Start-Sleep -Seconds 60
			}

			default {
				Write-Host "$exceptionError"
			}

		}
	}
}