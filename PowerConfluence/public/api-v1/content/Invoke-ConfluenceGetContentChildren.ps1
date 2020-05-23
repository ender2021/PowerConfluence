$ConfluenceChildExpand = @("attachment","comments","page")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-child-get
function Invoke-ConfluenceGetContentChildren {
    [CmdletBinding()]
    param (
        # The ID of the content to delete
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # The current version of the content
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [Alias("ParentVersion")]
        [int32]
        $CurrentVersion,

        # Used to expand additional attributes
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceChildExpand $_ })]
        [string[]]
        $Expand,

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/content/$ContentId/child"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}
        if($PSBoundParameters.ContainsKey("CurrentVersion")){$query.Add("parentVersion",$CurrentVersion)}

        $method = New-PACRestMethod $functionPath $verb $query
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}