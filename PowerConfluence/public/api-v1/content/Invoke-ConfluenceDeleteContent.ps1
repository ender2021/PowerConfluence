#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-delete
function Invoke-ConfluenceDeleteContent {
    [CmdletBinding()]
    param (
        # The ID of the content to delete
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # Set this flag to purge trashed content
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $Purge,

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
            FunctionPath = "/wiki/rest/api/content/$ContentId"
            HttpMethod = "DELETE"
            Query = @{}
        }
        if ($Purge) {$RestArgs.Query.Add("status","trashed")}

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        #$results
    }
}