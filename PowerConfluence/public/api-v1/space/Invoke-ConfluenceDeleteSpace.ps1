#https://developer.atlassian.com/cloud/confluence/rest/#api-space-delete
function Invoke-ConfluenceDeleteSpace {
    [CmdletBinding()]
    param (
        # The key of the new space
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("SpaceKey")]
        [string]
        $Key,

        # The ConfluenceConnection object to use for the request
        [Parameter(Position=1)]
        [hashtable]
        $ConfluenceConnection
    )
    begin {
        $results = @()
    }
    process {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/space/$Key"
            HttpMethod = "DELETE"
        }

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}