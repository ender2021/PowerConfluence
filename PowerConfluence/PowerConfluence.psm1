using module .\classes\html\ConfluenceHtmlTable.psm1
using module .\classes\html\ConfluenceHtmlTableCell.psm1
using module .\classes\html\ConfluenceHtmlTableRow.psm1
using module .\classes\html\ConfluenceHtmlTag.psm1
using module .\classes\macros\PowerConfluenceMacro.psm1
using module .\classes\macros\PowerConfluenceMessageBoxMacro.psm1
using module .\classes\macros\PowerConfluencePagePropertiesMacro.psm1
using module .\classes\macros\PowerConfluencePagePropertiesReportMacro.psm1
using module .\classes\macros\PowerConfluenceStatusMacro.psm1

# grab functions from files
$privateFiles = Get-ChildItem -Path $PSScriptRoot\private -Recurse -Include *.ps1 -ErrorAction SilentlyContinue
$publicFiles = Get-ChildItem -Path $PSScriptRoot\public -Recurse -Include *.ps1 -ErrorAction SilentlyContinue

if(@($privateFiles).Count -gt 0) { $privateFiles.FullName | ForEach-Object { . $_ } }
if(@($publicFiles).Count -gt 0) { $publicFiles.FullName | ForEach-Object { . $_ } }

Export-ModuleMember -Function $publicFiles.BaseName

$onRemove = {
	
}

$ExecutionContext.SessionState.Module.OnRemove += $onRemove
Register-EngineEvent -SourceIdentifier ([System.Management.Automation.PsEngineEvent]::Exiting) -Action $onRemove