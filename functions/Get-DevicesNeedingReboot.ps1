# Function to get devices needing reboot from all sites
function Get-DevicesNeedingReboot {
    # Iterate through all sites to get devices and filter those that need rebooting
    $sites = Get-DrmmAccountSites

    # Create an empty array to store devices needing reboot with converted timestamps
    $devicesNeedingRebootList = @()

    foreach ($site in $sites) {
        $siteUid = $site.uid
        $siteDevices = Get-DrmmSiteDevices -siteUid $siteUid

        # Filter devices that need rebooting
        $devicesNeedingReboot = $siteDevices | Where-Object { $_.RebootRequired -eq $true }

        if ($devicesNeedingReboot.Count -gt 0) {
            foreach ($device in $devicesNeedingReboot) {
                # Convert Last Reboot Time and Last Seen from Unix timestamp to DateTime
                $device | Add-Member -MemberType NoteProperty -Name "LastRebootDateTime" -Value ([System.DateTimeOffset]::FromUnixTimeMilliseconds($device.lastReboot).DateTime)
                $device | Add-Member -MemberType NoteProperty -Name "LastSeenDateTime" -Value ([System.DateTimeOffset]::FromUnixTimeMilliseconds($device.lastSeen).DateTime)
                $devicesNeedingRebootList += $device
            }
        }
    }

    # Sort the list by Last Reboot Time, oldest first
    $sortedDevices = $devicesNeedingRebootList | Sort-Object -Property LastRebootDateTime

    # Display the sorted list
    foreach ($device in $sortedDevices) {
        Write-Host "Hostname: $($device.hostname)"
        Write-Host "Sitename: $($device.sitename)"
        Write-Host "Description: $($device.description)"
        Write-Host "Last Reboot Time: $($device.LastRebootDateTime)"
        Write-Host "Last Seen: $($device.LastSeenDateTime)"
        Write-Host "Online: $($device.Online)"
        Write-Host "Portal URL: <a href='$($device.portalUrl)'>View on Web</a>"
        Write-Host "----"
    }
}
