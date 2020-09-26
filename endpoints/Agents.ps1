<#
  .Synopsis
  Get's a list of agents from Atera

  .Parameter CustomerID
  A Customer ID to filter down agents to

  .Example
  Get-AteraAgents | Where-Object { $_.OSType -eq "Domain Controller"}
  # Get all domain controllers

  .Example
  Get-AteraAgents | ForEach-Object { $_.IPAddresses = $_.IPAddresses -join ","; $_} | Export-CSV -Path "Agents.csv"
  # Get agents into a CSV file fixing IP Addresses into a list

  .Example
  Get-AteraCustomers | Where CustomerName -eq "Unassigned" | Get-AteraAgents
  # Get unassigned agents
#>
function Get-AteraAgents {
  param(
    # Customer ID to retrieve list of agents for
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName)]
    [int]$CustomerID
  )
  $uri = "/agents"
  if ($CustomerID) { $uri = "$uri/customer/$CustomerID" }
  return New-AteraGetRequest -Endpoint $uri
}

<#
  .Synopsis
  Gets information about a single agents

  .Parameter AgentID
  The ID of the agent to retrieve

  .Parameter MachineName
  Hostname of the agent to retrieve (defaults to current hostname)

  .Example
  Get-AteraAgent
  # Get information about the system running the command

  .Example
  Get-AteraAgent -MachineName "SOME-DC-01"
  # Get information about agent named "SOME-DC-01"

  .Example
  Get-AteraAgent -AgentID 1234
  # Get an agent based on it's ID

#>
function Get-AteraAgent {
  ##############
  # If no param is given the function will get the current PC
  ##############
  param(
    # ID of agent to retrieve
    [Parameter(Mandatory=$false,ParameterSetName="AgentID")]
    [int]$AgentID,
    # Machine Name; Default hostname of PC
    [Parameter(Mandatory=$false,ParameterSetName="MachineName")]
    [string]$MachineName=$env:COMPUTERNAME
  )
  if($ID){
    return New-AteraGetRequest -Endpoint "/agents/$AgentID"
  }
  if($MachineName){
    return New-AteraGetRequest -Endpoint "/agents/machine/$MachineName"
  }
}
