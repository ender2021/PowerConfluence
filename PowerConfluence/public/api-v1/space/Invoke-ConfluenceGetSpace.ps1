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

        # The ConfluenceConnection object to use for the request
        [Parameter(Position=2)]
        [hashtable]
        $ConfluenceConnection
    )
    begin {
        $results = @()
    }
    process {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/space/$SpaceKey"
            HttpMethod = "GET"
            Query = @{}
        }
        if($PSBoundParameters.ContainsKey("Expand")){$RestArgs.Query.Add("expand",$Expand -join ",")}

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}