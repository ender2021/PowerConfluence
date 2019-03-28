#https://developer.atlassian.com/cloud/confluence/rest/#api-content-get
function Invoke-ConfluenceGetContent ($ConfluenceConnection,$PageID,$SpaceKey,$Title,$Expand=$()) {
    
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