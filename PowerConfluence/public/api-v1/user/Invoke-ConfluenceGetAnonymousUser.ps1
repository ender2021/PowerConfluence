$ConfluenceAnonUserExpand = @("operations")

#https://developer.atlassian.com/cloud/confluence/rest/#api-api-user-anonymous-get
function Invoke-ConfluenceGetAnonymousUser {
    [CmdletBinding()]
    param (
        # properties to expand
        [Parameter(Position=0)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceAnonUserExpand $_ })]
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
        $functionPath = "/wiki/rest/api/user/anonymous"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}

        $method = New-PACRestMethod $functionPath $verb $query
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}