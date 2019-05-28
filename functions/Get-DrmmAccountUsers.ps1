function Get-DrmmAccountUsers
{

<#
.SYNOPSIS
Fetches the authentication users records of the authenticated user's account

.DESCRIPTION
Returns account user details.

{
  "pageDetails": {
    "count": 0,
    "nextPageUrl": "string",
    "prevPageUrl": "string"
  },
  "users": [
    {
      "created": 0,
      "disabled": true,
      "email": "string",
      "firstName": "string",
      "lastAccess": 0,
      "lastName": "string",
      "status": "string",
      "telephone": "string",
      "username": "string"
    }
  ]
}

#>

    # Declare Variables
    $apiMethod = 'GET'
    $maxPage = 50
    $nextPageUrl = $null
    $page = 0
    $Results = @()

    do 
    {
	    $Response = New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/account/users?max=$maxPage&page=$page" | ConvertFrom-Json
	    if ($Response)
	    {
		    $nextPageUrl = $Response.pageDetails.nextPageUrl
		    $Results += $Response.users
		    $page++
	    }
    }
    until ($nextPageUrl -eq $null)

    # Return all account devices
    return $Results
}