function Get-DrmmActivityLogs {

	<#
	.SYNOPSIS
	Fetches the RMM activity logs.

	.DESCRIPTION
	Returns the RMM activity logs.
	
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
		[string]$SortOrder

    )

	$Epoch = Get-Date 1/1/1970

	$RequestUri = "/v2/activity-logs?"
	$queryParams = New-Object System.Collections.Generic.List[System.String]

    # Add parameters to the queryParams list if they are set
    if ($LogTypes) { $queryParams.Add("entities=$($LogTypes -join ',')") }
    if ($Categories) { $queryParams.Add("categories=$($Categories -join ',')") }
    if ($Actions) { $queryParams.Add("actions=$($Actions -join ',')") }
    if ($SiteIds) { $queryParams.Add("siteIds=$($SiteIds -join ',')") }
    if ($UserIds) { $queryParams.Add("userIds=$($UserIds -join ',')") }
    if ($StartDateTime) { $queryParams.Add("from=$($StartDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ'))") }
    if ($EndDateTime) { $queryParams.Add("until=$($EndDateTime.ToString('yyyy-MM-ddTHH:mm:ssZ'))") }
    if ($Limit) { $queryParams.Add("size=$Limit") }
    if ($SortOrder) { $queryParams.Add("order=$SortOrder") }

    # Append the query parameters to the RequestUri
    if ($queryParams.Count -gt 0) {
        $RequestUri += [string]::Join('&', $queryParams)
    }
	
	# Query Activity Logs
	$ActivityLogs = do {

		$Response = New-ApiRequest -apiMethod "GET" -apiRequest $RequestUri | ConvertFrom-Json
		If ($Response.pageDetails.nextPageUrl){
			$RequestUri = $Response.pageDetails.nextPageUrl.split("api")[-1]
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
		$ActivityLog.date = $Epoch.AddSeconds($ActivityLog.date)

		# Iterate through details and convert applicable dates to datetime objects
		ForEach ($Detail in $ActivityLog.details.PSObject.Properties.Name){
			# Convert the date to a datetime object
			If (
				($Detail -match "start" -or $Detail -match "end" -or $Detail -match "time" -or $Detail -match "date") -and
				$ActivityLog.details.$Detail -as [bigint]
			){
				$ActivityLog.details.$Detail = $Epoch.AddMilliseconds($ActivityLog.details.$Detail)
			}
		}
	}

	# Return the activity logs
	return $ActivityLogs

}