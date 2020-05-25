$ConfluenceUserExpand = @("operations", "details.personal", "details.business", "personalSpace")

#https://developer.atlassian.com/cloud/confluence/rest/#api-api-user-get
function Invoke-ConfluenceGetUser {
    [CmdletBinding()]
    param (
        # the account id of the user to retrieve
        [Parameter(Mandatory,Position=0)]
        [string]
        $AccountId,

        # properties to expand
        [Parameter(Position=1)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceUserExpand $_ })]
        [string[]]
        $Expand,

        # The AtlassianContext object to use for the request
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/user"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{
            accountId = $AccountId
        }
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}

        $method = New-PACRestMethod $functionPath $verb $query
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}