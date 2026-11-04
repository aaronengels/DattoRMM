function Get-DrmmAccountDnetSiteMappings {

	<#
	.SYNOPSIS
	Fetches the sites of the authenticated user's account with their mapped Datto Networking network ids.

	.DESCRIPTION
	Returns one record per site: id, uid, name, description, portalUrl and dattoNetworkingNetworkIds
	(the Datto Networking networks mapped to that site).

	.EXAMPLE
	Get-DrmmAccountDnetSiteMappings | Where-Object { $_.dattoNetworkingNetworkIds }

	#>

	# Return all site mappings
	return New-ApiPagedRequest -apiRequest '/v2/account/dnet-site-mappings' -resultProperty 'dnetSiteMappings'
}
