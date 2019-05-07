#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-label-label-delete
function Invoke-ConfluenceRemoveContentLabel {
    [CmdletBinding()]
    param (
        # The id of the content
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # The label to remove
        [Parameter(Mandatory,Position=1,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]
        $Label,

        # The ConfluenceConnection object to use for the request
        [Parameter(Position=2)]
        [hashtable]
        $ConfluenceConnection
    )
    begin {
        $results = @()
    }
    process {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/content/$ContentId/label/$Label"
            HttpMethod = "DELETE"
        }

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        #$results
    }
}