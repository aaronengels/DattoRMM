function Set-DrmmApiParameters {
	[Alias('Connect-DrmmApi')]
	<#
	.SYNOPSIS
	Sets the API Parameters used throughout the module.

	.PARAMETER Url
	Provide Datto RMM API Url. See Datto RMM API help files for more information.

	.PARAMETER Key
	Provide Datto RMM API Key. Obtained when creating a API user in Datto RMM.

	.PARAMETER SecretKey
	Provide Datto RMM API ScretKey. Obtained when creating a API user in Datto RMM.

	.PARAMETER Credential
	Provides Datto RMM Api Key and SecretKey as credential.  Key is used as Username and SecretKye as Password.
	#>

	Param(
		[Parameter(Mandatory=$True)]
		[ValidateSet(
			"https://pinotage-api.centrastage.net",
			"https://merlot-api.centrastage.net",
			"https://concord-api.centrastage.net",
			"https://zinfandel-api.centrastage.net",
			"https://syrah-api.centrastage.net",
   			"https://vidal-api.centrastage.net"
		)]
		$Url,

		[Parameter(Mandatory=$True, ParameterSetName='Key')]
		[string]
		$Key,

		[Parameter(Mandatory=$True, ParameterSetName='Key')]
		[string]
		$SecretKey,

		[Parameter(Mandatory=$True, ParameterSetName='Credential')]
		[ValidateNotNull()]
		[Management.Automation.PSCredential]
		[Management.Automation.Credential()]
		$Credential
	)

	$script:ApiUrl = $Url

	if ($PSCmdlet.ParameterSetName -eq 'Key') {
		$Password = ConvertTo-SecureString -String $SecretKey -AsPlainText -Force
		$Credential = [Management.Automation.PSCredential]::new(
			$key,
			$Password
		)
	}
	$script:ApiAccessToken = New-ApiAccessToken -Credential $Credential
}
