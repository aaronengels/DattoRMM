function Set-DrmmApiParameters{
	<#
	.SYNOPSIS
	Sets the API Parameters used throughout the module.

	.PARAMETER Url
	Provide Datto RMM API Url. See Datto RMM API help files for more information.

	.PARAMETER Key
	Provide Dattto RMM API Key. Obtained when creating a API user in Datto RMM.

	.PARAMETER SecretKey
	Provide Datto RMM API ScretKey. Obtained when creating a API user in Datto RMM.
	
	#>
	
	Param(
	[Parameter(Mandatory=$True)]
	$Url,
    
	[Parameter(Mandatory=$True)]
	$Key,

	[Parameter(Mandatory=$True)]
	$SecretKey
	
	)

	New-Variable -Name apiUrl -Value $Url -Scope Script -Force
	New-Variable -Name apiKey -Value $Key -Scope Script -Force
	New-Variable -Name apiSecretKey -Value $SecretKey -Scope Script -Force
	
	$accessToken = New-ApiAccessToken
	New-Variable -Name apiAccessToken -value $accessToken -Scope Script -Force
}
