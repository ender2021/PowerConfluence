#https://developer.atlassian.com/cloud/confluence/rest/#api-space-delete
function Invoke-ConfluenceDeleteSpace {
    [CmdletBinding()]
    param (
        # The key of the new space
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("SpaceKey")]
        [string]
        $Key,

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/space/$Key"
        $verb = "DELETE"

        $method = New-PACRestMethod $functionPath $verb
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}