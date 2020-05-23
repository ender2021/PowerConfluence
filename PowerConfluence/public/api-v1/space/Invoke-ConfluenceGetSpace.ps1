$ConfluenceSpaceExpand = @("settings","metadata.labels","operations","lookAndFeel"
                           "permissions","icon","description.plain","description.view"
                           "theme","homepage")

#https://developer.atlassian.com/cloud/confluence/rest/#api-space-spaceKey-get
function Invoke-ConfluenceGetSpace {
    [CmdletBinding()]
    param (
        # The key of the space to retrieve
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Key")]
        [string]
        $SpaceKey,

        # Used to expand additional attributes
        [Parameter(Position=1)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceSpaceExpand $_ })]
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
        $functionPath = "/wiki/rest/api/space/$SpaceKey"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}

        $method = New-PACRestMethod $functionPath $verb
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}