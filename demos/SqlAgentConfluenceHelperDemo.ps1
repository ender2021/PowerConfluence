Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence.psm1) -Force
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\helpers\SqlAgentConfluenceHelper.psm1) -Force
Import-Module .\Credentials.psm1 -Force

########################################
#                                      #
#  DEMOS OF SQLAGENTCONFLUENCEHELPER   #
#                                      #
########################################

#########################
# common API parameters #
#########################

$ConfluenceConnection = Get-ConfluenceConnection -UserName $Credentials.UserName -ApiToken $Credentials.ApiToken -HostName $Credentials.HostName
$SqlAgentServerDev = $Credentials.SqlAgentServerDev
$spaceKey = "GSD"

########################################
# xml experiments                      #
########################################
<#
$page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title "Complex Layout Test" -Expand @("body.storage")
$storage = $page.body.storage.value
$content = Get-ConfluenceUserContent -TemplateContent $storage -UserSectionMap $PC_ConfluenceTemplates.Layout.UserSection.ComplexMap
$content -join "`n"
#$xml = [xml]($storage.Replace($PC_ConfluenceTemplates.Layout.LayoutStart, $PC_ConfluenceTemplates.Layout.LayoutStartWithNamespace))
#$xml.layout.ChildNodes
#$items = Select-Xml -Xml $xml -XPath '/ac:section' -Namespace @{ac="confluence.atlassian.com"}
#$items

#$XPath = "/ac:layout/Type/Members/AliasProperty"
#Select-Xml -Xml $body -XPath $Xpath | Select-Object -ExpandProperty Node
#>

########################################
# refresh a full SqlAgentJob manifest  #
########################################

<#
$scheduleTitle = "Job Schedule - Blue DEV Jobs"

$manifest = Publish-SqlAgentJobManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -PageTitle "SQL Agent Jobs - Blue DEV" -SchedulePageTitle $scheduleTitle

$jobs = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev | Where-Object { $_.Name.StartsWith("isis", "CurrentCultureIgnoreCase") }

$schedules = $jobs | Get-SqlAgentJobScheduleWithTranslation | Sort-Object -Property @{e={$_.JobEnabled -and $_.IsEnabled}; a=0},@{e={$_.JobEnabled}; a=0},FrequencyTypes,FrequencyRecurrenceFactor,ActiveStartTimeOfDay,Parent
Publish-SqlAgentScheduleSummaryConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title $scheduleTitle -Schedules $schedules -AncestorID $manifest.id

foreach ($job in $jobs) {
    Publish-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SqlAgentJob $job -SpaceKey $spaceKey -AncestorID $manifest.id
}
#>

########################################
# refresh a SqlAgentJob manifest page  #
########################################

<#
Publish-SqlAgentJobManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -PageTitle "SQL Agent Jobs - GradDiv DEV" -SchedulePageTitle "Job Schedule - GradDiv DEV Jobs"
#>

###########################################
# (re)generate a set of SqlAgentJob pages #
###########################################

<#
$jobs = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev | ? { $_.Name.StartsWith("GradDiv", "CurrentCultureIgnoreCase") }
foreach ($job in $jobs) {
    Publish-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SqlAgentJob $job -SpaceKey $spaceKey -AncestorID 312246349
}
#>

########################################
# refresh a SqlAgentJob profile page   #
########################################

<#
$job = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev -Name "GradDiv - Download Degree Files [H] NeoBatch [Production Ready]"
Publish-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SqlAgentJob $job -SpaceKey $spaceKey -AncestorID 312868932
#>

########################################
# refresh a job schedule overview page #
########################################

<#
$title = "Job Schedule - iSIS DEV Jobs"
$schedules = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev | ? { $_.Name.StartsWith("isis", "CurrentCultureIgnoreCase") }  | Get-SqlAgentJobScheduleWithTranslation | Sort-Object -Property @{e={$_.JobEnabled -and $_.IsEnabled}; a=0},@{e={$_.JobEnabled}; a=0},FrequencyTypes,FrequencyRecurrenceFactor,ActiveStartTimeOfDay,Parent
Publish-SqlAgentScheduleSummaryConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title $title -Schedules $schedules
#>

############################
# update a Confluence page #
############################

#$results = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID 312377422 -Expand @("body.storage","version")
#Get-ConfluenceUserContent -TemplateContent $results.body.storage.value
#Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID 312377422 -CurrentVersion $results.version.number -Title ($results.title.Substring(0,$results.title.IndexOf("(")) + " (v. " + ($results.version.number + 1) + ")") -Contents $results.body.storage.value


#########################
# get a Confluence page #
#########################

<#
$results = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title "Job Schedule - GradDiv DEV Jobs" -Expand @("metadata.labels")
#$results = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID 312377422
$filtered
#>

########################################
# post an agent job page to Confluence #
########################################

<#
$job = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev -Name "GradDiv - Load X Tables"
$pageContents = Format-SqlAgentJobConfluencePage($job)
$title = "GradDiv - Load X Tables"
Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title $title -Contents $pageContents -AncestorID 312246349
#>