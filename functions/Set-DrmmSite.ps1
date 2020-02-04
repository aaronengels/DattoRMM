function Set-DrmmSite {

	<#
	.SYNOPSIS
	Creates a new site in the authenticated user's account.

	.PARAMETER siteUid
	Provide site uid which will be used to update proxy settings.

	.PARAMETER siteName
	provide sitename.

	.PRAMETER siteDescription
	Provice site description.

	.PARAMETER siteNotes
	Provide site notes.
	
	.PARAMETER onDemand
	Will mark site as a on demand site

	.PARARMETER splashtopAutoInstall
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

	# Validate Site UID
	if($siteUid.GetType().Name -ne 'String') {
		return 'The Site UID is not a String!'
	}
	elseif($siteUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Site UID format is incorrect!'
	}	

	# Declare Variables
	$apiMethod = 'POST'
	$updateSiteRequest = @{}
	$Results = @()

	# Create update site request
	$updateSiteRequest.Add('name',$siteName)
	If ($PSBoundParameters.ContainsKey('siteDescription')) {$updateSiteRequest.Add('description',$siteDescription)}
	If ($PSBoundParameters.ContainsKey('siteNotes')) {$updateSiteRequest.Add('notes',$siteNotes)}
	If ($PSBoundParameters.ContainsKey('onDemand')) {$updateSiteRequest.Add('onDemand',$onDemand)}
	If ($PSBoundParameters.ContainsKey('plashtopAutoInstall')) {$updateSiteRequest.Add('dplashtopAutoInstall',$plashtopAutoInstall)}

	# Convert to JSON
	$Body = $updateSiteRequest | ConvertTo-Json

	# Update UDFs
	$Results = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/site/$siteUid" -apiRequestBody $Body | ConvertFrom-Json
	return $Results

}