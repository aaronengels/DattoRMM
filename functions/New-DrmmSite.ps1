function New-DrmmSite {

	<#
	.SYNOPSIS
	Creates a new site in the authenticated user's account.

	.PARAMETER siteName
	provide sitename.

	.PRAMETER siteDescription
	Provice site description.

	.PARAMETER siteNotes
	Provide site notes.
	
	.PARAMETER onDemand
	Will mark site as a on demand site.

	.PARARMETER splashtopAutoInstall
	Will switch on autoinstall spashtop.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $siteName,

        [Parameter(Mandatory=$False)] 
        $siteDescription,

        [Parameter(Mandatory=$False)] 
        $siteNotes,

        [Parameter(Mandatory=$False)] 
        [switch]$onDemand,

        [Parameter(Mandatory=$False)] 
        [switch]$splashtopAutoInstall
    )
	

	# Declare Variables
	$apiMethod = 'PUT'
	$createSiteRequest = @{}
	$Results = @()

	# Create site request
	$createSiteRequest.Add('name',$siteName)
	If ($PSBoundParameters.ContainsKey('siteDescription')) {$createSiteRequest.Add('description',$siteDescription)}
	If ($PSBoundParameters.ContainsKey('siteNotes')) {$createSiteRequest.Add('notes',$siteNotes)}
	If ($PSBoundParameters.ContainsKey('onDemand')) {$createSiteRequest.Add('onDemand',$onDemand)}
	If ($PSBoundParameters.ContainsKey('plashtopAutoInstall')) {$createSiteRequest.Add('dplashtopAutoInstall',$plashtopAutoInstall)}

	# Convert to JSON
	$Body = $createSiteRequest | ConvertTo-Json

	# Update UDFs
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}