function Get-DrmmAlert {

	<#
	.SYNOPSIS
	Fetches data of the alert identified by the given alert Uid.

	.DESCRIPTION
	Returns details of a specific alert.
	
	Alert {
	alertContext (AlertContext, optional),
	alertMonitorInfo (AlertMonitorInfo, optional),
	alertSourceInfo (AlertSourceInfo, optional),
	alertUid (string, optional),
	autoresolveMins (integer, optional),
	diagnostics (string, optional),
	muted (boolean, optional),
	priority (string, optional) = ['Critical', 'High', 'Moderate', 'Low', 'Information', 'Unknown'],
	resolved (boolean, optional),
	resolvedBy (string, optional),
	resolvedOn (integer, optional),
	responseActions (Array[ResponseAction], optional),
	ticketNumber (string, optional),
	timestamp (integer, optional)
	}
	AlertContext {}
	AlertMonitorInfo {
	createsTicket (boolean, optional),
	sendsEmails (boolean, optional)
	}
	AlertSourceInfo {
	deviceName (string, optional),
	deviceUid (string, optional),
	siteName (string, optional),
	siteUid (string, optional)
	}
	ResponseAction {
	actionReference (string, optional),
	actionTime (integer, optional),
	actionType (string, optional) = ['EMAIL_SENT', 'EMAIL_SEND_ERROR', 'TICKET_PENDING', 'TICKET_CREATED', 'TICKET_CREATION_ERROR', 'TICKET_CLOSED_CALL'],
	description (string, optional)
	}

	.PARAMMETER alertUid
	Provide alert uid which will be use to return alert details.
	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $alertUid
    )
    
	# Validate Alert UID
	if($alertUid.GetType().Name -ne 'String') {
		return 'The Alert UID is not a String!'
	}
	elseif($alertUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Alert UID format is incorrect!'
	}

	# Declare Variables
    $apiMethod = 'GET'

	# Return all alert details
	$Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/alert/$alertUid" | ConvertFrom-Json
	return $Response

}