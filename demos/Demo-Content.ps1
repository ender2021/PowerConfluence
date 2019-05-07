#import PowerConfluence
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \..\PowerConfluence\PowerConfluence.psm1) -Force

#import the variable $ConfluenceCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

#open a new Confluence session
Open-ConfluenceSession -UserName $ConfluenceCredentials.UserName -Password $ConfluenceCredentials.ApiToken -HostName $ConfluenceCredentials.HostName

#do tests here

#ADD LABELS TO CONTENT
#17137665 | Invoke-ConfluenceAddLabelsToContent -Label "test2"
#@("test3","test4") | Invoke-ConfluenceAddLabelsToContent 755826903

#GET CONTENT
#Invoke-ConfluenceGetContent "Test Page" "~justin.mead"

#GET CONTENT BY ID
#Invoke-ConfluenceGetContentById 755826903
#@(755826903,747111944) | Invoke-ConfluenceGetContentById

#CREATE CONTENT
#@("auto test 1","auto test 2") | Invoke-ConfluenceCreateContent "JPT" -Body (New-ConfluenceContentBody "")
#Invoke-ConfluenceCreateContent JPT "comment title" (New-ConfluenceContentBody "this is a comment") -Type "comment" -ParentId 17137665

#UPDATE CONTENT
#Invoke-ConfluenceGetContentById 755794103 | ForEach-Object {$_.title += " (Edited)";$_} | Invoke-ConfluenceUpdateContent

#CREATE OR UPDATE ATTACHMENT
#Get-Item $PSScriptRoot\SampleAttachment* | Invoke-ConfluenceCreateOrUpdateAttachment 17137665
#Get-Item $PSScriptRoot\SampleAttachment* | Invoke-ConfluenceCreateOrUpdateAttachment 17137665 -ForceCreate

#DELETE CONTENT
#17006719 | Invoke-ConfluenceDeleteContent

#GET CONTENT CHILDREN
#(Invoke-ConfluenceGetContentChildren 17137665 -Expand "attachment").attachment

#GET CONTENT LABELS
#Invoke-ConfluenceGetContentLabels 17137665

#GET ATTACHMENTS
#Invoke-ConfluenceGetAttachments 17137665

#GET CONTENT COMMENTS
#Invoke-ConfluenceGetContentComments 17137665

#end tests

#close the Confluence session
Close-ConfluenceSession