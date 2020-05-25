# https://developer.atlassian.com/cloud/confluence/rest/#api-api-group-groupName-get
function Invoke-ConfluenceGetGroup {
    [CmdletBinding()]
    param (
        # The name of the group to retrieve
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("GroupName")]
        [string]
        $Name,

        # The AtlassianContext object to use for the request
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/group/$Name"
        $verb = "GET"

        $method = New-PACRestMethod $functionPath $verb
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}