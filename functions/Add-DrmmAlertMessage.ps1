function Add-DrmmAlertMessage {

	<#
	.SYNOPSIS
	Adds a alert message to a alert.

	.PARAMETER Alert
	A object containing the alert.

	#>

	# Function Parameters
	Param (
		[Parameter(ValueFromPipeline = $true)]
		$alert
	)

	# Add Alert Message
	switch ($alert.alertContext.'@class') {	
		
		'antivirus_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Antivirus'
			$message = "AV {0} {1}" -f $alert.alertContext.productName, $alert.alertContext.Status
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}		
		
		'eventlog_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'EventLog'
			$message = "{0} (Event Code: {1} - Event Type {2})" -f $alert.alertContext.description, $alert.alertContext.code, $alert.alertContext.type
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'comp_script_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Component'
			$statusValue = $alert.alertContext.samples.psobject.properties.value
			$message = "{0}" -f $statusValue
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'fs_object_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'FileFolderSize'
			$message = "File/Folder {0} {1}" -f $alert.alertContext.path, $alert.alertContext.sample
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'online_offline_status_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Offline'
			$message = "Device {0} {1}" -f $alert.alertSourceInfo.deviceName, $alert.alertContext.status
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'patch_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Patch'
			$message = "{0}" -f $alert.alertContext.info
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'perf_disk_usage_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Disk'
			$message = "Disk {0} has {1}% space left" -f $alert.alertContext.diskName, [math]::Round((($alert.alertContext.freeSpace / $alert.alertContext.totalVolume) * 100))
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'perf_mon_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Performance'
			$message = "Performance Monitor returned value {0}" -f $alert.alertContext.value
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'perf_resource_usage_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Performance'
			if ($alert.alertContext.type -eq 'CPU') {
				$message = "CPU reached {0}%" -f $alert.alertContext.percentage
			}
			if ($alert.alertContext.type -eq 'MEMORY') {
				$message = "Memory reached {0}%" -f $alert.alertContext.percentage
			}
			if ($alert.alertContext.type -eq 'SNMP_THROUGHPUT') {
				$message = "SNMP thoughput reached {0}%" -f $alert.alertContext.percentage
			}
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'ping_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Ping'
			$status = $alert.alertContext.reasons | Out-String -Stream
			$message = "Ping roundtrip {0} {1}" -f $alert.alertContext.roundtripTime, $status
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'process_resource_usage_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Process'
			if ($alert.alertContext.type -eq 'CPU') {
				$message = "Process {0} CPU reached {1}%" -f $alert.alertContext.processName, [math]::Round($alert.alertContext.sample)
			}
			if ($alert.alertContext.type -eq 'MEMORY') {
				$message = "Process {0} memory reached {1}%" -f $alert.alertContext.processName, [math]::Round($alert.alertContext.sample)
			}
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'process_status_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Process'
			$message = "Process {0} {1}" -f $alert.alertContext.processName, $alert.alertContext.status
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'sec_management_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Webroot'
			$message = @"
			Webroot $($alert.alertContext.status)"
			$(if ($alert.alertContext.virusName) {
				"Found {0} virus. " -f $alert.alertContext.virusName
			}
			if ($alert.alertContext.infectedFiles) {
				"Found {0} infected files. " -f $alert.alertContext.infectedFiles
			}
			if ($alert.alertContext.productNotUpdatedForDays) {
				"Product not updated for {0} day(s). " -f $alert.alertContext.productNotUpdatedForDays
			}
			if ($alert.alertContext.systemRemainsInfectedForHours) {
				"Sytem remained infected for {0} hour(s). " -f $alert.alertContext.systemRemainsInfectedForHours
			}
			if ($alert.alertContext.expiryLicenseForDays) {
				"License expired for {0} day(s). " -f $alert.alertContext.expiryLicenseForDays
			})
"@
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'srvc_resource_usage_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Service'
			if ($alert.alertContext.type -eq 'CPU') {
				$message = "Service {0} CPU reached {1}%" -f $alert.alertContext.serviceName, [math]::Round($alert.alertContext.sample)
			}
			if ($alert.alertContext.type -eq 'MEMORY') {
				$message = "Service {0} memory reached {1}%" -f $alert.alertContext.serviceName, [math]::Round($alert.alertContext.sample)
			}
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'srvc_status_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Service'
			$message = "Service {0} {1}" -f $alert.alertContext.serviceName, $alert.alertContext.status
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'sw_action_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'Software'
			$message = "Software {0} {1} {2} " -f $alert.alertContext.packageName, $alert.alertContext.version, $alert.alertContext.actionType
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

		'wmi_ctx' {
			$alert | Add-Member -MemberType NoteProperty -Name 'alertType' -Value 'WMI'
			$message = "WMI result {0} " -f $alert.alertContext.value
			$alert | Add-Member -MemberType NoteProperty -Name 'alertMessage' -Value $message
		}

	}

	return $alert
}