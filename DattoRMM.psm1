[CmdletBinding()]
Param(
  [Parameter(
	Position = 0,
    Mandatory = $true
  )]
  [String]
  $global:apiUrl,
    
  [Parameter(
	Position = 1,
    Mandatory = $true 
  )]
  [String]
  $global:apiKey,

  [Parameter(
	Position = 2,
    Mandatory = $true
  )]
  [String]
  $global:apiSecretKey
)

# Import functions
$Functions = @( Get-ChildItem -Path $PSScriptRoot\functions\*.ps1 -ErrorAction SilentlyContinue ) 
foreach ($Import in @($Functions))
{
  try
  {
    . $Import.fullname
  }
  catch
  {
    throw "Could not import function $($Import.fullname): $_"
  }
}

