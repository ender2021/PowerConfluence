#https://developer.atlassian.com/cloud/confluence/rest/#api-longtask-get
function Invoke-ConfluenceGetLongRunningTasks {
    [CmdletBinding()]
    param (
        # The index of the first item to return in the page of results (page offset). The base index is 0.
        [Parameter(Position=0,ValueFromPipelineByPropertyName)]
        [int32]
        $StartAt=0,

        # The maximum number of items to return per page. The default is 100 and the maximum is 100.
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [ValidateRange(1,100)]
        [int32]
        $MaxResults=100,


        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/longtask"
            HttpMethod = "GET"
            Query = @{
                start = $StartAt
                limit = $MaxResults
            }
        }

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}