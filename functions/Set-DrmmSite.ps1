function Set-DrmmSite {

	<#
	.SYNOPSIS
	Updates a new site in the authenticated user's account.

	.PARAMETER SiteUid
	Provide site uid which will be used to update proxy settings.

	.PARAMETER SiteName
	Provide sitename.

	.PRAMETER SiteDescription
	Provide site description.

	.PARAMETER SiteNotes
	Provide site notes.
	
	.PARAMETER OnDemand
	Will mark site as a on demand site

	.PARAMETER SplashtopAutoInstall
	Will switch on autoinstall spashtop.

	#>

	# Function Parameters
    Param (

        [Parameter(Mandatory=$True)] 
        $siteUid,

        [Parameter(Mandatory=$True)] 
        $siteName,

        [Parameter(Mandatory=$False)] 
        $siteDescription,

        [Parameter(Mandatory=$False)] 
        $siteNotes,

        [Parameter(Mandatory=$False)] 
        [bool]$onDemand,

        [Parameter(Mandatory=$False)] 
        [switch]$splashtopAutoInstall
    )

	# Declare Variables
	$apiMethod = 'POST'
	$updateSiteRequest = @{}

	# Create update site request
	$updateSiteRequest.Add('name',$siteName)
	If ($PSBoundParameters.ContainsKey('siteDescription')) {$updateSiteRequest.Add('description',$siteDescription)}
	If ($PSBoundParameters.ContainsKey('siteNotes')) {$updateSiteRequest.Add('notes',$siteNotes)}
	If ($PSBoundParameters.ContainsKey('onDemand')) {$updateSiteRequest.Add('onDemand',$onDemand)}
	If ($PSBoundParameters.ContainsKey('splashtopAutoInstall')) {$updateSiteRequest.Add('splashtopAutoInstall',$True)}

	# Convert to JSON
	$Body = $updateSiteRequest | ConvertTo-Json

	# Create Site and return results
	return New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid" -apiRequestBody $Body | ConvertFrom-Json

}