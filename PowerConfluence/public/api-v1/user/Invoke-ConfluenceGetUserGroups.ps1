
#https://developer.atlassian.com/cloud/confluence/rest/#api-api-user-memberof-get
function Invoke-ConfluenceGetUserGroups {
    [CmdletBinding()]
    param (
        # the account id of the user to retrieve
        [Parameter(Mandatory,Position=0)]
        [string]
        $AccountId,

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
        $functionPath = "/wiki/rest/api/user/memberof"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{
            accountId = $AccountId
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