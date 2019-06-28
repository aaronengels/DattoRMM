function Get-DrmmAccountAlertsResolved {

	<#
	.SYNOPSIS
	Fetches resolved alerts of the authenticated user's account

	.DESCRIPTION
	Returns account resolved alerts.

	AlertsPage {
	alerts (Array[Alert]),
	pageDetails (PaginationData)
	}
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
	PaginationData {
	count (integer, optional),
	nextPageUrl (string, optional),
	prevPageUrl (string, optional)
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

	.PARAMETER muted
	Use this switch to only show muted alerts

	#>


    # Function Parameters
    Param (
        [Parameter(Mandatory=$False)]
        [Switch]$muted
    )

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/alerts/resolved?max=$maxPage&page=$page&muted=$muted" | ConvertFrom-Json
	    if ($Response) {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.Alerts
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all sites except the 'Deleted Devices' site
    return $Results

}