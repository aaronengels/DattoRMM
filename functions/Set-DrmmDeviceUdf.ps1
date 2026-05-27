function Set-DrmmDeviceUdf {

	<#
    .SYNOPSIS
    Sets one or more Datto RMM Device User Defined Fields.

    .DESCRIPTION
    Updates only the UDF keys that are supplied in UdfData.
    Supported keys are udf1 through udf300.
    Any supplied key with an empty string value will be sent as null.
    All UDF keys not supplied will retain their current value.

    .PARAMETER DeviceUid
    The Datto RMM device UID for which UDF values should be updated.

    .PARAMETER UdfData
    Hashtable or object containing UDF key/value pairs to update.
    Keys must use the format udf<number>, for example udf1, udf25, udf300.

    .EXAMPLE
    Set-DrmmDeviceUdf -DeviceUid "abc123" -UdfData @{ udf1 = "Server"; udf300 = "" }
    Sets udf1 to "Server" and clears udf300 by sending null.

    .OUTPUTS
    [psobject] API response from New-ApiRequest.

	#>

	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
	param(
		[Parameter(Mandatory = $true, HelpMessage = "Provide device uid which will be used to set UDF(s)")]
		[ValidateNotNullOrEmpty()]
		[string]$DeviceUid,

		[Parameter(Mandatory = $true, HelpMessage = "Provide UDF key/value pairs, for example @{ udf1 = 'Value'; udf300 = '' }")]
		[ValidateNotNull()]
		[object]$UdfData
	)

	begin {
	}

	process {
		try {
			$ApiMethod = 'POST'
			$Udfs = @{}

			if ($PSBoundParameters.ContainsKey('UdfData')) {
				if ($UdfData -is [hashtable]) {
					$UdfEnumerator = $UdfData.GetEnumerator()
				} else {
					$UdfEnumerator = $UdfData.PSObject.Properties
				}

				foreach ($Entry in $UdfEnumerator) {
					$Key = [string]$Entry.Name
					$Value = $Entry.Value

					if ($Key -notmatch '^udf([1-9][0-9]{0,2})$') {
						throw "Invalid UDF key '$Key'. Expected format is udf<number> (for example udf1, udf25, udf300)."
					}

					$UdfNumber = [int]$Matches[1]
					if ($UdfNumber -lt 1 -or $UdfNumber -gt 300) {
						throw "Invalid UDF key '$Key'. UDF number must be between 1 and 300."
					}

					if ($Value -is [string] -and [string]::IsNullOrEmpty($Value)) {
						$Udfs[$Key] = $null
					} else {
						$Udfs[$Key] = $Value
					}
				}
			}

			if ($Udfs.Count -eq 0) {
				throw 'No UDF values were provided. Use -UdfData with one or more udf<number> keys.'
			}

			$Body = $Udfs | ConvertTo-Json -Depth 5

			if ($PSCmdlet.ShouldProcess($DeviceUid, 'Update Datto RMM device UDF values')) {
				return New-ApiRequest -apiMethod $ApiMethod -apiRequest "/v2/device/$DeviceUid/udf" -apiRequestBody $Body
			}
		} catch {
			throw $_
		}
	}

	end {
	}
}
