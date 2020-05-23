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

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/content/$ContentId/label/$Label"
        $verb = "DELETE"

        $method = New-PACRestMethod $functionPath $verb
        $results += $method.Invoke($RequestContext)
    }
    end {
        #$results
    }
}