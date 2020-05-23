$ConfluenceContentExpand = @("childTypes.all","childTypes.attachment","childTypes.comment","childTypes.page",
                             "container","metadata.currentuser","metadata.properties","metadata.labels",
                             "metadata.frontend","operations","children.page","children.attachment","children.comment",
                             "restrictions.read.restrictions.user","restrictions.read.restrictions.group",
                             "restrictions.update.restrictions.user","restrictions.update.restrictions.group",
                             "history","history.lastUpdated","history.previousVersion","history.contributors",
                             "history.nextVersion","ancestors","body","version","descendants.page",
                             "descendants.attachment","descendants.comment","space")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-child-comment-get
function Invoke-ConfluenceGetContentComments {
    [CmdletBinding()]
    param (
        # The id of the content
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # The current version of the content
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [Alias("ParentVersion")]
        [int32]
        $CurrentVersion,

        # The location of comments in the page to return (?)
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [string[]]
        $Location,

        # The index of the first item to return in the page of results (page offset). The base index is 0.
        [Parameter(Position=3)]
        [int32]
        $StartAt=0,

        # The maximum number of items to return per page. The default is 200 and the maximum is 200.
        [Parameter(Position=4)]
        [ValidateRange(1,200)]
        [int32]
        $MaxResults=200,

        # Used to expand additional attributes
        [Parameter(Position=5,ValueFromPipelineByPropertyName)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceContentExpand $_ })]
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
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/content/$ContentId/child/comment"
            HttpMethod = "GET"
            Query = @{
                start = $StartAt
                limit = $MaxResults
            }
        }
        if($PSBoundParameters.ContainsKey("Expand")){$RestArgs.Query.Add("expand",$Expand -join ",")}
        if($PSBoundParameters.ContainsKey("CurrentVersion")){$RestArgs.Query.Add("parentVersion",$CurrentVersion)}
        if($PSBoundParameters.ContainsKey("Location")){$RestArgs.Query.Add("location",$Location)}

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}