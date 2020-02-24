function Set-DrmmSite {

	<#
	.SYNOPSIS
	Updates a new site in the authenticated user's account.

	.PARAMETER siteUid
	Provide site uid which will be used to update proxy settings.

	.PARAMETER siteName
	Provide sitename.

	.PRAMETER siteDescription
	Provide site description.

	.PARAMETER siteNotes
	Provide site notes.
	
	.PARAMETER onDemand
	Will mark site as a on demand site

	.PARAMETER splashtopAutoInstall
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
        [switch]$onDemand,

        [Parameter(Mandatory=$False)] 
        [switch]$splashtopAutoInstall
    )

	# Declare Variables
	$apiMethod = 'POST'
	$updateSiteRequest = @{}
	$Results = @()

	# Create update site request
	$updateSiteRequest.Add('name',$siteName)
	If ($PSBoundParameters.ContainsKey('siteDescription')) {$updateSiteRequest.Add('description',$siteDescription)}
	If ($PSBoundParameters.ContainsKey('siteNotes')) {$updateSiteRequest.Add('notes',$siteNotes)}
	If ($PSBoundParameters.ContainsKey('onDemand')) {$updateSiteRequest.Add('onDemand',$True)}
	If ($PSBoundParameters.ContainsKey('splashtopAutoInstall')) {$updateSiteRequest.Add('splashtopAutoInstall',$True)}

	# Convert to JSON
	$Body = $updateSiteRequest | ConvertTo-Json

	# Create Site and return results
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}