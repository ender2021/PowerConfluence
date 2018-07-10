####################################
# basic Confluence posting support #
####################################

function Send-ConfluenceRestRequest($ConfluenceConnection,$FunctionAddress,$HttpMethod,$Headers=@{},$Body) {
    
    $sendHeaders = @{}
    $sendHeaders += $ConfluenceConnection.AuthHeader
    $sendHeaders += $Headers

    #define url
    $restApiPath = "/wiki/rest/api/"
    $url =  $ConfluenceConnection.HostName + $restApiPath + (Format-ConfluenceApiFunctionAddress -Address $FunctionAddress)

    if ($Body) {
        Invoke-RestMethod -Uri $url -Method $HttpMethod -ContentType 'application/json' -Headers $sendHeaders -Body (ConvertTo-Json $Body -Compress)
    } else {
        Invoke-RestMethod -Uri $url -Method $HttpMethod -ContentType 'application/json' -Headers $sendHeaders
    }
}

function Format-ConfluenceApiFunctionAddress($Address) {
    (&{If($Address.StartsWith("/")) {$Address.Substring(1)} else {$Address}})
}

function Add-ConfluencePage ($ConfluenceConnection,$SpaceKey,$AncestorID = -1,$Title,$Contents) {
    #build the body
    $messageBody = @{
        body = @{
            storage = @{
                representation = "storage";
                value = $Contents
            }
        };
        space = @{
            key = $SpaceKey
        };
        title = $Title
        type = "page"
    }
    if ($AncestorID -ne -1) {
        $messageBody.Add("ancestors", @(@{id=$AncestorID}))
    }
    
    Send-ConfluenceRestRequest -ConfluenceConnection $ConfluenceConnection -FunctionAddress "content" -HttpMethod Post -Body $messageBody
}

function Update-ConfluencePage ($ConfluenceConnection,$PageID,$CurrentVersion,$Title,$Contents) {
    #build the body
    $messageBody = @{
        body = @{
            storage = @{
                representation = "storage";
                value = $Contents
            }
        };
        version = @{
            number = $CurrentVersion + 1
        };
        title = $Title;
        type = "page"
    }
    
    Send-ConfluenceRestRequest -ConfluenceConnection $ConfluenceConnection -FunctionAddress "content/$PageID" -HttpMethod Put -Body $messageBody
}

function Add-ConfluencePageLabel($ConfluenceConnection,$PageID,$LabelName) {
    $body = @(@{name=$LabelName;prefix="global"})
    $function = "content/$PageID/label"
    Send-ConfluenceRestRequest -ConfluenceConnection $ConfluenceConnection -FunctionAddress $function -HttpMethod Post -Body $body
}

function Get-ConfluencePage ($ConfluenceConnection,$PageID,$SpaceKey,$Title,$Expand=$()) {
    
    # create the expand parameter, if any were requested
    $expandString = (&{if($Expand.Count -gt 0) {"expand=" + ($Expand -join ",") } else {""}})
    
    if ($PageID) {
        # if a pageID is supplied, do a Get Content by ID call
        $functionStr = "content/$PageID" + (&{if($expandString -ne "") { "`?$expandString" } else {""}})
    } elseif ($SpaceKey -and $Title) {
        # if a space key and title are supplied, do a Get Content call filtered by space and title
        $encodedTitle = [System.Web.HttpUtility]::UrlEncode($Title) 
        $functionStr = "content?title=$encodedTitle&spaceKey=$SpaceKey" + (&{if($expandString -ne "") { "&$expandString" } else {""}})
    } else {
        # if none of the necessary search parameters were supplied, send the fool packing
        Throw "You must provide either a -PageID or -SpaceKey and -Title!"
    }

    # wrap the call in a Try/Catch in case we get a 400 error
    Try
    {
        # send the request and save the results
        $results = Send-ConfluenceRestRequest $ConfluenceConnection -FunctionAddress $functionStr -HttpMethod Get

        # if we didn't so a search by id, the results will be in list format
        # pull the result out of the list to return, or throw an error if there's not exactly 1 result
        if (-not $PageID) {
            if ($results.size = 1) {
                $results = $results.results[0]
            } else {
                Throw "No page found"
            }
        }

    }
    Catch
    {
        # if anything went wrong, just set the results to null and let the caller handle it
        $results = $null
    }
    Finally {
        # no matter what happens, return something
        $results    
    }
}

function Get-ConfluenceUserContent($TemplateContent,$UserContentSectionIndex = 1) {
    # use the supplied parameter to determine the location of the user content
    # split the TemplateContent in two parts - before the start of the user content (throw away), and after (keep)
    $userContent = $TemplateContent.Substring(([regex]::Matches($TemplateContent, $_confluenceTemplates.Layout.SectionStart))[$UserContentSectionIndex].Index)

    # take the piece that starts with the user content and chop off anything after the end of the user content (aka, the first Confluence Section end)
    $userContent = $userContent.Substring(0, ([regex]::Matches($userContent, $_confluenceTemplates.Layout.SectionEnd))[0].Index + $_confluenceTemplates.Layout.SectionEnd.Length)
    
    # return
    $userContent
}

function Get-ConfluenceConnection($UserName,$ApiToken,$HostName) {
    # create the unencoded string
    $credentialsText = "$UserName`:$ApiToken"

    # encode the string in base64
    $credentialsBytes = [System.Text.Encoding]::UTF8.GetBytes($credentialsText)
    $encodedCredentials = [Convert]::ToBase64String($credentialsBytes)

    # format the host name
    $formattedHost = (&{If($HostName.EndsWith("/")) {$HostName.Substring(0,$HostName.Length-1)} else {$HostName}})

    @{
        AuthHeader = @{Authorization="Basic $encodedCredentials"}
        HostName = $formattedHost
    }    
}

Export-ModuleMember -Function * -Variable *