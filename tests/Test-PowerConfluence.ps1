Import-Module $PSScriptRoot\..\PowerConfluence\PowerConfluence.psm1 -Force

# grab private functions from files
$privateFiles = Get-ChildItem -Path $PSScriptRoot\..\PowerConfluence\private -Recurse -Include *.ps1 -ErrorAction SilentlyContinue
if(@($privateFiles).Count -gt 0) { $privateFiles.FullName | ForEach-Object { . $_ } }

Invoke-Pester $PSScriptRoot -Show Failed, Summary