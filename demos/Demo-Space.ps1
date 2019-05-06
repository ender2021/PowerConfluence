#import PowerConfluence
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence\PowerConfluence.psm1) -Force

#import the variable $ConfluenceCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#open a new Confluence session
Open-ConfluenceSession -UserName $ConfluenceCredentials.UserName -Password $ConfluenceCredentials.ApiToken -HostName $ConfluenceCredentials.HostName

#do tests here

#GET SPACES
#Invoke-ConfluenceGetSpaces
#Invoke-ConfluenceGetSpaces "GA"
#@("GA","CR","GCCW") | Invoke-ConfluenceGetSpaces

#GET SPACE
#Invoke-ConfluenceGetSpace "GA"
#@("GA","CR","GCCW") | Invoke-ConfluenceGetSpace

#CREATE SPACE
#Invoke-ConfluenceCreateSpace "JPT" "Justin Powershell Testing" "A space where justin tests some powershell stuff"

#UPDATE SPACE
#Invoke-ConfluenceUpdateSpace "JPT" "Justin's PowerShell Testing"

#DELETE SPACE
#"JPT" | Invoke-ConfluenceDeleteSpace

#end tests

#close the Confluence session
Close-ConfluenceSession