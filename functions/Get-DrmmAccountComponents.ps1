function Get-DrmmAccountComponents {

	<#
	.SYNOPSIS
	Fetches the components records of the authenticated user's account.

	.DESCRIPTION
	Returns account installed components.

	ComponentsPage {
	components (Array[Component]),
	pageDetails (PaginationData)
	}
	Component {
	categoryCode (string, optional),
	credentialsRequired (boolean, optional),
	description (string, optional),
	id (integer, optional),
	name (string, optional),
	uid (string, optional),
	variables (Array[ComponentVariable], optional)
	}
	PaginationData {
	count (integer, optional),
	nextPageUrl (string, optional),
	prevPageUrl (string, optional)
	}
	ComponentVariable {
	defaultVal (string, optional),
	description (string, optional),
	direction (boolean, optional),
	name (string, optional),
	type (string, optional),
	variablesIdx (integer, optional)
	}
	}

	#>

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/components?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response) {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.components
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all account installed components
    return $Results
}