#import PowerConfluence
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence\PowerConfluence.psd1) -Force

#import the variable $ConfluenceCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#open a new Confluence session
Open-ConfluenceSession -UserName $ConfluenceCredentials.UserName -Password $ConfluenceCredentials.ApiToken -HostName $ConfluenceCredentials.HostName

#do tests here

#GET USER
#Invoke-ConfluenceGetUser '557058:36b19b6f-d1af-4707-9e2d-dcce63f2231d' -Expand "operations"

#GET CURRENT USER
#Invoke-ConfluenceGetCurrentUser

#end tests

#close the Confluence session
Close-ConfluenceSession