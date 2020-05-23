#https://developer.atlassian.com/cloud/confluence/rest/#api-longtask-id-get
function Invoke-ConfluenceGetLongRunningTask {
    [CmdletBinding()]
    param (
        # The Id of the task
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $TaskId,

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
            FunctionPath = "/wiki/rest/api/longtask/$TaskId"
            HttpMethod = "GET"
        }

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}