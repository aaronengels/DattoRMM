function Set-DrmmAlertMute {

	<#
	.SYNOPSIS
	Mutes the alert identified by the given alert Uid.

	.DESCRIPTION
	Mute and alert providing the alert Uid.

	.PARAMETER AlertUid
	Provide alert Uid to mute the alert.
	
	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $alertUid
    )
	
	Throw "As of Datto RMM 8.9.0 alerts cannot be muted or unmuted. `nFunction Set-DrmmAlertMute has been deprecated.`nhttps://help.aem.autotask.net/en/Content/0HOME/ReleaseNotes/2020/ReleaseNotesDattoRMMv8.9.0.htm"

}