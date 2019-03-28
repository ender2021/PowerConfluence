#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-label-post
function Invoke-ConfluenceAddLabelsToContent($ConfluenceConnection,$PageID,$LabelName) {
    $body = @(@{name=$LabelName;prefix="global"})
    $function = "content/$PageID/label"
    Send-ConfluenceRestRequest -ConfluenceConnection $ConfluenceConnection -FunctionAddress $function -HttpMethod Post -Body $body
}