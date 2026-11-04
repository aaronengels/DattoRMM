function Wait-DrmmJob {

	<#
	.SYNOPSIS
	Waits for a job to finish and returns its result.

	.DESCRIPTION
	Polls the job until it finishes or the timeout passes.
	With -DeviceUid it polls that device's job result (GET /v2/job/{jobUid}/results/{deviceUid}) until
	jobDeploymentStatus is no longer Pending or Running, and returns the device result. -IncludeOutput
	adds the StdOut and StdErr of each component.
	Without -DeviceUid it polls the job status (GET /v2/job/{jobUid}) until it is 'completed'.
	On timeout it writes an error with the last status seen and returns nothing.

	.PARAMETER JobUid
	Provide the job uid, e.g. the job.uid returned by Set-DrmmDeviceQuickJob.

	.PARAMETER DeviceUid
	Optional device uid. Waits for this device's result instead of the overall job status.

	.PARAMETER IncludeOutput
	With -DeviceUid: also return the StdOut and StdErr text of each component.

	.PARAMETER TimeoutSeconds
	How long to wait before giving up (default 600 seconds).

	.PARAMETER PollSeconds
	How often to check (default 15 seconds).

	.OUTPUTS
	Without -DeviceUid: the job (id, uid, name, status, dateCreated).
	With -DeviceUid: jobUid, deviceUid, jobDeploymentStatus, ranOn, componentResults and, with
	-IncludeOutput, StdOut and StdErr.

	.EXAMPLE
	$job = Set-DrmmDeviceQuickJob -deviceUid $uid -jobName 'Diag' -ComponentUid $componentUid
	$result = Wait-DrmmJob -jobUid $job.job.uid -deviceUid $uid -IncludeOutput
	$result.jobDeploymentStatus; $result.StdOut

	#>

	# Function Parameters
	Param (
		[Parameter(Mandatory=$True, Position=0)]
		[ValidateNotNullOrEmpty()]
		[string]$jobUid,

		[Parameter(Mandatory=$False)]
		[ValidateNotNullOrEmpty()]
		[string]$deviceUid,

		[Parameter(Mandatory=$False)]
		[switch]$IncludeOutput,

		[Parameter(Mandatory=$False)]
		[ValidateRange(1, 86400)]
		[int]$TimeoutSeconds = 600,

		[Parameter(Mandatory=$False)]
		[ValidateRange(1, 3600)]
		[int]$PollSeconds = 15
	)

	$jobPath = [uri]::EscapeDataString($jobUid)
	$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
	$lastStatus = 'unknown'

	while ($true) {
		if ($PSBoundParameters.ContainsKey('deviceUid')) {
			# The device result can 404 until the device picks the job up, so errors here mean "not yet"
			$result = New-ApiRequest -apiMethod 'GET' -apiRequest "/v2/job/$jobPath/results/$([uri]::EscapeDataString($deviceUid))" -ErrorAction SilentlyContinue | ConvertFrom-Json
			if ($result) {
				$lastStatus = $result.jobDeploymentStatus
				if ($lastStatus -and $lastStatus -notin 'Pending', 'Running') {
					if ($IncludeOutput) {
						$stdOut = @(Get-DrmmJobResults -jobUid $jobUid -deviceUid $deviceUid -resultType StdOut -ErrorAction SilentlyContinue)
						$stdErr = @(Get-DrmmJobResults -jobUid $jobUid -deviceUid $deviceUid -resultType StdErr -ErrorAction SilentlyContinue)
						$result | Add-Member -MemberType NoteProperty -Name StdOut -Value (($stdOut | Where-Object { $_ } | ForEach-Object { $_.stdData }) -join "`n") -Force
						$result | Add-Member -MemberType NoteProperty -Name StdErr -Value (($stdErr | Where-Object { $_ } | ForEach-Object { $_.stdData }) -join "`n") -Force
					}
					return $result
				}
			}
		}
		else {
			$job = New-ApiRequest -apiMethod 'GET' -apiRequest "/v2/job/$jobPath" | ConvertFrom-Json
			if ($job) {
				$lastStatus = $job.status
				if ($lastStatus -eq 'completed') { return $job }
			}
		}

		if ((Get-Date).AddSeconds($PollSeconds) -gt $deadline) {
			$target = if ($PSBoundParameters.ContainsKey('deviceUid')) { "on device $deviceUid" } else { '' }
			Write-Error "Wait-DrmmJob : job $jobUid $target did not finish within $TimeoutSeconds seconds (last status: $lastStatus). Check that the device is online, or wait longer with -TimeoutSeconds."
			return
		}
		Write-Verbose "Wait-DrmmJob : job $jobUid status $lastStatus; checking again in $PollSeconds seconds"
		Start-Sleep -Seconds $PollSeconds
	}
}
