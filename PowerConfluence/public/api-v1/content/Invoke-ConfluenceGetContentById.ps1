$ConfluenceContentExpand = @("childTypes.all","childTypes.attachment","childTypes.comment","childTypes.page",
                             "container","metadata.currentuser","metadata.properties","metadata.labels",
                             "metadata.frontend","operations","children.page","children.attachment","children.comment",
                             "restrictions.read.restrictions.user","restrictions.read.restrictions.group",
                             "restrictions.update.restrictions.user","restrictions.update.restrictions.group",
                             "history","history.lastUpdated","history.previousVersion","history.contributors",
                             "history.nextVersion","ancestors","body","version","descendants.page",
                             "descendants.attachment","descendants.comment","space")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-get
function Invoke-ConfluenceGetContentById {
    [CmdletBinding()]
    param (
        # The Id of the content to retrieve
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("ContentId")]
        [int32]
        $Id,

        # Status of content to retrieve
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [ValidateSet("current", "trashed", "any", "draft")]
        [string]
        $Status = "current",

        # The version number to return
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [int32]
        $Version,

        # Used to expand additional attributes
        [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceContentExpand $_ })]
        [string[]]
        $Expand,

        # Set this flag to render embeded contents as the version they were when the content was saved
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $EmbedRenderAtSave,

        # Set this flag to triggered the "viewed" event for the content
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $TriggerView,

        # The ConfluenceConnection object to use for the request
        [Parameter(Position=4)]
        [hashtable]
        $ConfluenceConnection
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/content/$Id"
        $verb = "GET"

        $query=@{
            status = $Status
            embeddedContentRender = IIF $EmbedRenderAtSave "version-at-save" "current"
        }
        if($PSBoundParameters.ContainsKey("Version")){$query.Add("version",$Version)}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}
        if($TriggerView){$query.Add("trigger","viewed")}

        $results += Invoke-ConfluenceRestMethod $ConfluenceConnection $functionPath $verb -Query $query
    }
    end {
        $results
    }
}