function New-ApiAccessToken {

	<#
	.SYNOPSIS
	Fetches the the API token.

	.DESCRIPTION
	Returns the API token.

	.INPUTS
	$apiUrl = The API URL from module variables
	$Credential = The API Key (UserName) and Secret Key (Password)

	.OUTPUTS
	API Token

	#>

	param (
		[Parameter(Mandatory=$True)]
		[pscredential]
		$Credential
	)

	# Check API Parameters
	if (!$script:apiUrl) {
		Write-Host "API URL missing, please run Set-DrmmApiParameters first!"
		return
	}

	# add TLS 1.2 if missing
	[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]'Tls12'

	# Convert password to secure string
	$securePassword = ConvertTo-SecureString -String 'public' -AsPlainText -Force

	# Define parameters for Invoke-WebRequest cmdlet
	$params = @{
		Credential  = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ('public-client', $securePassword)
		Uri         = '{0}/auth/oauth/token' -f $apiUrl
		Method      = 'POST'
		ContentType = 'application/x-www-form-urlencoded'
		Body        = 'grant_type=password&username={0}&password={1}' -f $Credential.UserName, $Credential.GetNetworkCredential().Password
	}

	# Request access token
	try
	{
		(Invoke-WebRequest -UseBasicParsing @params | ConvertFrom-Json).access_token
	}
	catch
	{
		Write-Host $_.Exception.Message
	}
}
