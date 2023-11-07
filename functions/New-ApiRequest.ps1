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
    if (!$script:ApiUrl -or !$script:ApiAccessToken) {
        Write-Host "API Parameters missing, please run Set-DrmmApiParameters first!"
        return
    }

    # Define parameters for Invoke-WebRequest cmdlet
    $params = [ordered] @{
        Uri         = '{0}/api{1}' -f $script:ApiUrl, $apiRequest
        Method      = $apiMethod
        ContentType = 'application/json'
        Headers     = @{
            'Authorization' = 'Bearer {0}' -f $script:ApiAccessToken
        }
    }

    # Add body to parameters if present
    If ($apiRequestBody) {
        # Convert body to UTF8
        [byte[]]$apiRequestBody = [System.Text.Encoding]::UTF8.GetBytes($apiRequestBody)
        $params.Add('Body', $apiRequestBody)
    }

    $maxRetries = 3  # Maximum number of retries
    $retryCount = 0

    do {
        try {
            $response = Invoke-WebRequest -UseBasicParsing @params
            $content = [System.Text.Encoding]::UTF8.GetString($response.RawContentStream.ToArray())
            return $content  # Return successful response content and exit the function
        }
        catch {
            $errorObject = $_
            $exceptionError = $_.Exception.Message

            switch ($exceptionError) {
                'The remote server returned an error: (429).' {
                    Write-Warning 'New-ApiRequest : API rate limit breached, sleeping for 60 seconds'
                    Start-Sleep -Seconds 60
                }
                'The remote server returned an error: (403) Forbidden.' {
                    Write-Warning 'New-ApiRequest : AWS DDOS protection breached, sleeping for 5 minutes'
                    Start-Sleep -Seconds 300
                }
                'The remote server returned an error: (404) Not Found.' {
                    Write-Error "New-ApiRequest : $apiRequest not found!"
					return
                }
                'The remote server returned an error: (504) Gateway Timeout.' {
                    Write-Warning "New-ApiRequest : Gateway Timeout, sleeping for 60 seconds"
                    Start-Sleep -Seconds 60
                }
                default {
                    Write-Error $errorObject
					return
                }
            }
        }

        $retryCount++
        if ($retryCount -lt $maxRetries) {
            Write-Warning "New-ApiRequest : Retrying API request $apiRequest (Attempt $retryCount of $maxRetries)"
        }
        else {
            Write-Error "New-ApiRequest : Maximum retry attempts reached."
            break
        }
    } while ($retryCount -lt $maxRetries)

}
