#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-put
function Invoke-ConfluenceUpdateContent ($ConfluenceConnection,$PageID,$CurrentVersion,$Title,$Contents) {
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