function Get-DrmmAccountDevices {

	<#
	.SYNOPSIS
	Fetches the devices of the authenticated user's account.

	.DESCRIPTION
	Returns device data, including patch status, anti-virus status and user defined fields.
	
	.PARAMETER FilterId
	Optional parameter specifying a filter to return only some devices
	When FilterId is provided it alone decides the results; the API ignores the other filters.

	.PARAMETER Hostname
	Optional. Return only devices whose hostname contains this value (partial match).

	.PARAMETER DeviceType
	Optional. Return only devices whose device type contains this value (partial match), e.g. 'Server'.

	.PARAMETER OperatingSystem
	Optional. Return only devices whose operating system contains this value (partial match), e.g. 'Windows 11'.

	.PARAMETER SiteName
	Optional. Return only devices in sites whose name contains this value (partial match).

	.EXAMPLE
	Get-DrmmAccountDevices -OperatingSystem 'Windows Server' -SiteName 'Contoso'
	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$False)]
		[String]$FilterId,

		[Parameter(Mandatory=$False)]
		[ValidateNotNullOrEmpty()]
		[String]$Hostname,

		[Parameter(Mandatory=$False)]
		[ValidateNotNullOrEmpty()]
		[String]$DeviceType,

		[Parameter(Mandatory=$False)]
		[ValidateNotNullOrEmpty()]
		[String]$OperatingSystem,

		[Parameter(Mandatory=$False)]
		[ValidateNotNullOrEmpty()]
		[String]$SiteName
	)

	# Declare Variables
	$apiMethod = 'GET'
	$maxPage = 250
	$nextPageUrl = $null
	$page = 0
	if ( $PSBoundParameters.ContainsKey("FilterId") ) {
		$filterQuery = "&filterId=$FilterId"
	}
	# Partial-match filters, URL-encoded so spaces and symbols in the values are sent intact
	foreach ($filterName in 'Hostname', 'DeviceType', 'OperatingSystem', 'SiteName') {
		if ($PSBoundParameters.ContainsKey($filterName)) {
			$queryName = $filterName.Substring(0, 1).ToLowerInvariant() + $filterName.Substring(1)
			$filterQuery += '&{0}={1}' -f $queryName, [uri]::EscapeDataString($PSBoundParameters[$filterName])
		}
	}
	$Results = @()

	$Results = do {
		$Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/devices?max=$maxPage&page=$page$filterQuery" | ConvertFrom-Json
		if ($Response) {
			$nextPageUrl = $Response.pageDetails.nextPageUrl
			$Response.devices
			$page++
		}
	}
	until ($null -eq $nextPageUrl)

	# Return all account devices
	return $Results
}
