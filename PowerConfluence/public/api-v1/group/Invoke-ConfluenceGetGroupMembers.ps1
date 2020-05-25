# https://developer.atlassian.com/cloud/confluence/rest/#api-api-group-groupName-member-get
function Invoke-ConfluenceGetGroupMembers {
    [CmdletBinding()]
    param (
        # The name of the group to retrieve
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("GroupName")]
        [string]
        $Name,

        # The index to start results at
        [Parameter(Position=1)]
        [int]
        $StartAt = 0,

        # The maximum number of results to return
        [Parameter(Position=2)]
        [int]
        $MaxResults = 200,

        # The AtlassianContext object to use for the request
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/group/$Name/member"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{
            start = $StartAt
            limit = $MaxResults
        }

        $method = New-PACRestMethod $functionPath $verb $query
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}