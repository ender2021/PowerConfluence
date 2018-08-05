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
$spaceKey = "PCTS"


########################################
# refresh a full Integration Services Package manifest  #
########################################


$manifest = Publish-IntegrationServicesPackageManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -PageTitle "Package Manifest - GradDiv Prod" -SchedulePageTitle $scheduleTitle

$catalog = (Get-IntegrationServicesCatalog -ServerName $SqlAgentServerDev)
$project = $catalog.Folders["Ucsb.Sa.DataManagement.IntegrationServices"].Projects["Ucsb.Sa.DataManagement.IntegrationServices.GradDiv"]
foreach ($package in $project.Packages) {
    Publish-IntegrationServicesPackageConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Package $package -Catalog $catalog -AncestorID $manifest.id
}
#>

########################################################
#      PUBLISH PACKAGE PROFILE PAGE                       #
########################################################

<#
$catalog = (Get-IntegrationServicesCatalog -ServerName $SqlAgentServerDev)
$package = $catalog.Folders["Ucsb.Sa.DataManagement.IntegrationServices"].Projects["Ucsb.Sa.DataManagement.IntegrationServices.GradDiv"].Packages["GradDiv - Load GRE.dtsx"]

Publish-IntegrationServicesPackageConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Package $package -Catalog $catalog
#>

########################################################
#      TOP 100 RECENT EXECUTIONS MANIFEST              #
########################################################

<#
$catalog = (Get-IntegrationServicesCatalog -ServerName $SqlAgentServerDev)
$executions = Get-IntegrationServicesRecentExecutions -Executions $catalog.Executions -Count 100
Publish-IntegrationServicesExecutionManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title "Integration Services - 100 Most Recent Executions" -Executions $executions
#>

########################################################
#      OLD JUNK                                        #
########################################################

# Get-SsisPackageList -ServerName $SqlAgentServerDev -FolderName "Ucsb.Sa.DataManagement.IntegrationService" -ProjectName "Ucsb.Sa.DataManagement.IntegrationServices.GradDiv" | Format-Table -Property PackageId,NameSqlAgentServerDev