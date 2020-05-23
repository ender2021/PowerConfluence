$ConfluenceContentExpand = @("childTypes.all","childTypes.attachment","childTypes.comment","childTypes.page",
                             "container","metadata.currentuser","metadata.properties","metadata.labels",
                             "metadata.frontend","operations","children.page","children.attachment","children.comment",
                             "restrictions.read.restrictions.user","restrictions.read.restrictions.group",
                             "restrictions.update.restrictions.user","restrictions.update.restrictions.group",
                             "history","history.lastUpdated","history.previousVersion","history.contributors",
                             "history.nextVersion","ancestors","body","version","descendants.page",
                             "descendants.attachment","descendants.comment","space")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-post
function Invoke-ConfluenceCreateContent {
    [CmdletBinding()]
    param (
        # Space key of the space to create the content in
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [string]
        $SpaceKey,

        # The title of the content
        [Parameter(Mandatory,Position=1,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateLength(1,255)]
        [string]
        $Title,

        # The body of the content.  Use New-ConfluenceContentBody
        [Parameter(Mandatory,Position=2,ValueFromPipelineByPropertyName)]
        [Alias("Body")]
        [pscustomobject]
        $ContentBody,

        # The ID of the content parent
        [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        [int32]
        $ParentId,

        # The ID of the draft content being published
        [Parameter(Position=4,ValueFromPipelineByPropertyName)]
        [int32]
        $Id,

        # The type of content to create. Defaults to page
        [Parameter(Position=5,ValueFromPipelineByPropertyName)]
        [ValidateSet("page","blogpost","comment","attachment")]
        [string]
        $Type="page",

        # The status of the content
        [Parameter(Position=6,ValueFromPipelineByPropertyName)]
        [ValidateSet("current","trashed","historical","draft")]
        [string]
        $Status="current",

        # Used to expand additional attributes
        [Parameter(Position=7,ValueFromPipelineByPropertyName)]
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
        $functionPath = "/wiki/rest/api/content"
        $verb = "POST"

        $query=@{}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}

        $body=@{
            space = @{key=$SpaceKey}
            type = $Type
            title = $Title
            status = $Status
            body = $ContentBody
        }
        if($PSBoundParameters.ContainsKey("ParentId")){
            if ($Type -eq "comment") {
                $body.Add("container",@{type="page";"id"=$ParentId})
            } else {
                $body.Add("ancestors",@(@{id=$ParentId}))
            }
        }
        if($PSBoundParameters.ContainsKey("Id")){$body.Add("id",$Id)}

        $results += Invoke-ConfluenceRestMethod $ConfluenceConnection $functionPath $verb -Query $query -Body $body
    }
    end {
        $results
    }
}