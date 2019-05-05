#import PowerConfluence
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence\PowerConfluence.psm1) -Force

#import the variable $ConfluenceCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#open a new Confluence session
Open-ConfluenceSession -UserName $ConfluenceCredentials.UserName -Password $ConfluenceCredentials.ApiToken -HostName $ConfluenceCredentials.HostName

#do tests here

#ADD LABELS TO CONTENT
#@(755826903,747111944) | Invoke-ConfluenceAddLabelsToContent -Label "test2"
#@("test3","test4") | Invoke-ConfluenceAddLabelsToContent 755826903

#GET CONTENT
#Invoke-ConfluenceGetContent "Test Page" "~justin.mead"

#GET CONTENT BY ID
#Invoke-ConfluenceGetContentById 755826903
#@(755826903,747111944) | Invoke-ConfluenceGetContentById

#end tests

#close the Confluence session
Close-ConfluenceSession