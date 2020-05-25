# https://developer.atlassian.com/cloud/confluence/rest/#api-api-group-get
function Invoke-ConfluenceGetGroups {
    [CmdletBinding()]
    param (
        # The index to start results at
        [Parameter(Position=0)]
        [int]
        $StartAt = 0,

        # The maximum number of results to return
        [Parameter(Position=1)]
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
        $functionPath = "/wiki/rest/api/group"
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