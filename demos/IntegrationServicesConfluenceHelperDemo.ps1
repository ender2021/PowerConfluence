Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence.psm1) -Force
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\helpers\IntegrationServicesConfluenceHelper.psm1) -Force
Import-Module .\Credentials.psm1 -Force

#######################################################
#                                                     #
#    DEMOS OF INTEGRATIONSERVICESCONFLUENCEHELPER     #
#                                                     #
#######################################################

$ConfluenceConnection = Get-ConfluenceConnection -UserName $Credentials.UserName -ApiToken $Credentials.ApiToken -HostName $Credentials.HostName
$SqlAgentServerDev = $Credentials.SqlAgentServerDev
$spaceKey = "GSD"

########################################################
#      TOP 100 RECENT EXECUTIONS MANIFEST              #
########################################################


$catalog = Get-IntegrationServicesCatalog -ServerName $SqlAgentServerDev
$topHundred = $catalog.Executions.GetList()[0..99]
Publish-IntegrationServicesExecutionManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title "Integration Services - 100 Most Recent Executions" -Executions $topHundred
#>

########################################################
#      OLD JUNK                                        #
########################################################

# Get-SsisPackageList -ServerName $SqlAgentServerDev -FolderName "Ucsb.Sa.DataManagement.IntegrationService" -ProjectName "Ucsb.Sa.DataManagement.IntegrationServices.GradDiv" | Format-Table -Property PackageId,NameSqlAgentServerDev