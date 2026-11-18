function ConvertTo-DrmmMacAddress {

	<#
	.SYNOPSIS
	Converts a MAC address to the format the Datto RMM API expects (XXXXXXXXXXXX).

	.DESCRIPTION
	Removes the separators ':', '-', '.' and spaces, checks that 12 hexadecimal digits remain and
	returns them in upper case. Throws if the value isn't a MAC address.

	.PARAMETER MacAddress
	The MAC address, e.g. 00:1A:2B:3C:4D:5E, 00-1A-2B-3C-4D-5E, 001A.2B3C.4D5E or 001A2B3C4D5E.

	.EXAMPLE
	ConvertTo-DrmmMacAddress -MacAddress '00:1a:2b:3c:4d:5e'
	Returns 001A2B3C4D5E

	#>

	Param (
		[Parameter(Mandatory=$True)]
		[string]$MacAddress
	)

	$mac = ($MacAddress.Trim() -replace '[:\-\.\s]', '').ToUpperInvariant()
	if ($mac -notmatch '^[0-9A-F]{12}$') {
		throw "'$MacAddress' is not a valid MAC address. Expected 12 hexadecimal digits, with or without ':', '-' or '.' separators, e.g. 00:1A:2B:3C:4D:5E or 001A2B3C4D5E."
	}
	return $mac
}
