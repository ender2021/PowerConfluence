#https://developer.atlassian.com/cloud/confluence/rest/#api-content-post
function Invoke-ConfluenceCreateContent ($ConfluenceConnection,$SpaceKey,$AncestorID = -1,$Title,$Contents) {
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
    
    Invoke-ConfluenceRestMethod -ConfluenceConnection $ConfluenceConnection -FunctionAddress "content" -HttpMethod Post -Body $messageBody
}