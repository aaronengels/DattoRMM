function New-DrmmSite {

	<#
	.SYNOPSIS
	Creates a new site in the authenticated user's account.

	.PARAMETER SiteName
	Provide sitename.

	.PARAMETER SiteDescription
	Provice site description.

	.PARAMETER SiteNotes
	Provide site notes.
	
	.PARAMETER OnDemand
	Will mark site as a on demand site.

	.PARAMETER SplashtopAutoInstall
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
	If ($PSBoundParameters.ContainsKey('onDemand')) {$createSiteRequest.Add('onDemand',$True)}
	If ($PSBoundParameters.ContainsKey('splashtopAutoInstall')) {$createSiteRequest.Add('splashtopAutoInstall',$True)}

	# Convert to JSON
	$Body = $createSiteRequest | ConvertTo-Json

	# Create Site and return results
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}