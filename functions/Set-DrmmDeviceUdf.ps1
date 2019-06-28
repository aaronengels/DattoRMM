function Set-DrmmDeviceUdf {

	<#
	.SYNOPSIS
	Sets a Datto RMM Device User Defined Field

	.DESCRIPTION
	Any user defined field supplied with an empty value will be set to null. 
	All user defined fields not supplied will retain their current value

	Udf {
	udf1 (string, optional),
	udf10 (string, optional),
	udf11 (string, optional),
	udf12 (string, optional),
	udf13 (string, optional),
	udf14 (string, optional),
	udf15 (string, optional),
	udf16 (string, optional),
	udf17 (string, optional),
	udf18 (string, optional),
	udf19 (string, optional),
	udf2 (string, optional),
	udf20 (string, optional),
	udf21 (string, optional),
	udf22 (string, optional),
	udf23 (string, optional),
	udf24 (string, optional),
	udf25 (string, optional),
	udf26 (string, optional),
	udf27 (string, optional),
	udf28 (string, optional),
	udf29 (string, optional),
	udf3 (string, optional),
	udf30 (string, optional),
	udf4 (string, optional),
	udf5 (string, optional),
	udf6 (string, optional),
	udf7 (string, optional),
	udf8 (string, optional),
	udf9 (string, optional)
	}

	.PARAMMETER deviceUid
	Provide device uid which will be use to return device UDFs.

	#>

	# Function Parameters
    Param (
        [Parameter(Mandatory=$True)] 
        $deviceUid,

		[Parameter(Mandatory=$False)]
		$udf1,

		[Parameter(Mandatory=$False)]
		$udf2,

		[Parameter(Mandatory=$False)]
		$udf3,

		[Parameter(Mandatory=$False)]
		$udf4,

		[Parameter(Mandatory=$False)]
		$udf5,

		[Parameter(Mandatory=$False)]
		$udf6,

		[Parameter(Mandatory=$False)]
		$udf7,

		[Parameter(Mandatory=$False)]
		$udf8,

		[Parameter(Mandatory=$False)]
		$udf9,

		[Parameter(Mandatory=$False)]
		$udf10,

		[Parameter(Mandatory=$False)]
		$udf11,

		[Parameter(Mandatory=$False)]
		$udf12,

		[Parameter(Mandatory=$False)]
		$udf13,

		[Parameter(Mandatory=$False)]
		$udf14,

		[Parameter(Mandatory=$False)]
		$udf15,

		[Parameter(Mandatory=$False)]
		$udf16,

		[Parameter(Mandatory=$False)]
		$udf17,

		[Parameter(Mandatory=$False)]
		$udf18,

		[Parameter(Mandatory=$False)]
		$udf19,

		[Parameter(Mandatory=$False)]
		$udf20,

		[Parameter(Mandatory=$False)]
		$udf21,

		[Parameter(Mandatory=$False)]
		$udf22,

		[Parameter(Mandatory=$False)]
		$udf23,

		[Parameter(Mandatory=$False)]
		$udf24,

		[Parameter(Mandatory=$False)]
		$udf25,

		[Parameter(Mandatory=$False)]
		$udf26,

		[Parameter(Mandatory=$False)]
		$udf27,

		[Parameter(Mandatory=$False)]
		$udf28,

		[Parameter(Mandatory=$False)]
		$udf29,

		[Parameter(Mandatory=$False)]
		$udf30
    )
	
	# Validate device UID
	if($deviceUid.GetType().Name -ne 'String') {
		return 'The Device UID is not a String!'
	}
	elseif($deviceUid -notmatch '[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}') {
		return 'The Device UID format is incorrect!'
	}

	# Declare Variables
		$apiMethod = 'POST'
		$Udfs = @{}

	# Add UDFs provided
	If ($PSBoundParameters.ContainsKey('udf1')) {$Udfs.Add('udf1',$udf1)}
	If ($PSBoundParameters.ContainsKey('udf2')) {$Udfs.Add('udf2',$udf2)}
	If ($PSBoundParameters.ContainsKey('udf3')) {$Udfs.Add('udf3',$udf3)}
	If ($PSBoundParameters.ContainsKey('udf4')) {$Udfs.Add('udf4',$udf4)}
	If ($PSBoundParameters.ContainsKey('udf5')) {$Udfs.Add('udf5',$udf5)}
	If ($PSBoundParameters.ContainsKey('udf6')) {$Udfs.Add('udf6',$udf6)}
	If ($PSBoundParameters.ContainsKey('udf7')) {$Udfs.Add('udf7',$udf7)}
	If ($PSBoundParameters.ContainsKey('udf8')) {$Udfs.Add('udf8',$udf8)}
	If ($PSBoundParameters.ContainsKey('udf9')) {$Udfs.Add('udf9',$udf9)}
	If ($PSBoundParameters.ContainsKey('udf10')) {$Udfs.Add('udf10',$udf10)}
	If ($PSBoundParameters.ContainsKey('udf11')) {$Udfs.Add('udf11',$udf11)}
	If ($PSBoundParameters.ContainsKey('udf12')) {$Udfs.Add('udf12',$udf12)}
	If ($PSBoundParameters.ContainsKey('udf13')) {$Udfs.Add('udf13',$udf13)}
	If ($PSBoundParameters.ContainsKey('udf14')) {$Udfs.Add('udf14',$udf14)}
	If ($PSBoundParameters.ContainsKey('udf15')) {$Udfs.Add('udf15',$udf15)}
	If ($PSBoundParameters.ContainsKey('udf16')) {$Udfs.Add('udf16',$udf16)}
	If ($PSBoundParameters.ContainsKey('udf17')) {$Udfs.Add('udf17',$udf17)}
	If ($PSBoundParameters.ContainsKey('udf18')) {$Udfs.Add('udf18',$udf18)}
	If ($PSBoundParameters.ContainsKey('udf19')) {$Udfs.Add('udf19',$udf19)}
	If ($PSBoundParameters.ContainsKey('udf20')) {$Udfs.Add('udf20',$udf20)}
	If ($PSBoundParameters.ContainsKey('udf21')) {$Udfs.Add('udf21',$udf21)}
	If ($PSBoundParameters.ContainsKey('udf22')) {$Udfs.Add('udf22',$udf22)}
	If ($PSBoundParameters.ContainsKey('udf23')) {$Udfs.Add('udf23',$udf23)}
	If ($PSBoundParameters.ContainsKey('udf24')) {$Udfs.Add('udf24',$udf24)}
	If ($PSBoundParameters.ContainsKey('udf25')) {$Udfs.Add('udf25',$udf25)}
	If ($PSBoundParameters.ContainsKey('udf26')) {$Udfs.Add('udf26',$udf26)}
	If ($PSBoundParameters.ContainsKey('udf27')) {$Udfs.Add('udf27',$udf27)}
	If ($PSBoundParameters.ContainsKey('udf28')) {$Udfs.Add('udf28',$udf28)}
	If ($PSBoundParameters.ContainsKey('udf29')) {$Udfs.Add('udf29',$udf29)}
	If ($PSBoundParameters.ContainsKey('udf30')) {$Udfs.Add('udf30',$udf30)}

	# Convert to JSON
	$Body = $Udfs | ConvertTo-Json

	# Update UDFs
	New-ApiRequest -apiMethod $apiMethod -apiRequest "/v2/device/$deviceUid/udf" -apiRequestBody $Body
}