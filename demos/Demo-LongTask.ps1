#import PowerConfluence
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence\PowerConfluence.psm1) -Force

#import the variable $ConfluenceCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#open a new Confluence session
Open-ConfluenceSession -UserName $ConfluenceCredentials.UserName -Password $ConfluenceCredentials.ApiToken -HostName $ConfluenceCredentials.HostName

#do tests here

#GET LONG RUNNING TASKS
#(Invoke-ConfluenceGetLongRunningTasks).results

#GET LONG RUNNING TASK
#Invoke-ConfluenceGetLongRunningTask 17072129

#end tests

#close the Confluence session
Close-ConfluenceSession