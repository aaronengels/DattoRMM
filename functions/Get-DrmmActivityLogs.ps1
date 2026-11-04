function Get-DrmmActivityLogs {

	<#
	.SYNOPSIS
	Fetches the RMM activity logs.

	.DESCRIPTION
	Returns the RMM activity logs.

	.PARAMETER SearchQuery
	Optional advanced search, using the same syntax as the Activity Log search field in the Datto RMM UI:
	single words, phrases, wildcards, boolean operators, fuzzy and grouped searches. Requires Datto RMM 15.0.0 or later.
	See https://rmm.datto.com/help/en/Content/3NEWUI/Analytics/ActivityLog.htm

	.EXAMPLE
	Get-DrmmActivityLogs -StartDateTime (Get-Date).AddDays(-1) -SearchQuery 'patch'

	#>

	# Function Parameters
    Param (

		[ValidateSet('device', 'user')]
		[string[]]$LogTypes,

		[string[]]$Categories,

		[string[]]$Actions,

		[int[]]$SiteIds,

		[int[]]$UserIds,

		[datetime]$StartDateTime,

		[datetime]$EndDateTime,

        [int]$Limit,

		[ValidateSet('asc','desc')]
		[string]$SortOrder,

		[string]$SearchQuery

    )

	$Epoch = [DateTime]::ParseExact('19700101Z','yyyyMMddZ',$Null).ToUniversalTime()

	$RequestUri = "/v2/activity-logs?"
	$queryParams = New-Object System.Collections.Generic.List[System.String]

    # Add parameters to the queryParams list if they are set
    if ($LogTypes) { $queryParams.Add("entities=$($LogTypes -join ',')") }
    if ($Categories) { $queryParams.Add("categories=$($Categories -join ',')") }
    if ($Actions) { $queryParams.Add("actions=$($Actions -join ',')") }
    if ($SiteIds) { $queryParams.Add("siteIds=$($SiteIds -join ',')") }
    if ($UserIds) { $queryParams.Add("userIds=$($UserIds -join ',')") }
    if ($StartDateTime) { $queryParams.Add("from=$($StartDateTime.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))") }
    if ($EndDateTime) { $queryParams.Add("until=$($EndDateTime.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))") }
    if ($Limit) { $queryParams.Add("size=$Limit") }
    if ($SortOrder) { $queryParams.Add("order=$SortOrder") }
    if ($SearchQuery) { $queryParams.Add("searchQuery=$([uri]::EscapeDataString($SearchQuery))") }

    # Append the query parameters to the RequestUri
    if ($queryParams.Count -gt 0) {
        $RequestUri += [string]::Join('&', $queryParams)
    }
	
	# Query Activity Logs
	$ActivityLogs = do {

		$Response = New-ApiRequest -apiMethod "GET" -apiRequest $RequestUri | ConvertFrom-Json
		If ($Response.pageDetails.nextPageUrl){
			# Keep everything after the host's "/api" prefix. Splitting on "api" and taking the last piece
			# broke when the query itself contained "api" (e.g. a searchQuery such as "rapid").
			$RequestUri = $Response.pageDetails.nextPageUrl -replace '^https?://[^/]+/api', ''
			$Response.activities
		}
	
	} while ($Response.pageDetails.nextPageUrl)

	# Expand properties for each activity
	ForEach ($ActivityLog in $ActivityLogs){
		# Convert details into an object
		$ActivityLog.details = $ActivityLog.details | ConvertFrom-Json

		# Flatten siteId
		$ActivityLog | Add-Member -MemberType NoteProperty -Name siteId -Value $ActivityLog.site.id -Force

		# Flatten siteName
		$ActivityLog | Add-Member -MemberType NoteProperty -Name siteName -Value $ActivityLog.site.name -Force

		# Remove the site object
		$ActivityLog.PSObject.Properties.Remove("site")

		# Convert date to a datetime object
		$ActivityLog.date = $Epoch.AddSeconds($ActivityLog.date).ToLocalTime()

		# Iterate through details and convert applicable dates to datetime objects
		ForEach ($Detail in $ActivityLog.details.PSObject.Properties.Name){
			# Convert the date to a datetime object
			If (
				($Detail -match "start" -or $Detail -match "end" -or $Detail -match "time" -or $Detail -match "date") -and
				$ActivityLog.details.$Detail -as [bigint]
			){
				$ActivityLog.details.$Detail = $Epoch.AddMilliseconds($ActivityLog.details.$Detail).ToLocalTime()
			}
		}
	}

	# Return the activity logs
	return $ActivityLogs

}
