$ConfluenceContentExpand = @("childTypes.all","childTypes.attachment","childTypes.comment","childTypes.page",
                             "container","metadata.currentuser","metadata.properties","metadata.labels",
                             "metadata.frontend","operations","children.page","children.attachment","children.comment",
                             "restrictions.read.restrictions.user","restrictions.read.restrictions.group",
                             "restrictions.update.restrictions.user","restrictions.update.restrictions.group",
                             "history","history.lastUpdated","history.previousVersion","history.contributors",
                             "history.nextVersion","ancestors","body","version","descendants.page",
                             "descendants.attachment","descendants.comment","space")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-child-attachment-get
function Invoke-ConfluenceGetAttachments {
    [CmdletBinding()]
    param (
        # The id of the content
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # A media type to filter results by
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [string]
        $MediaType,
        
        # A file name to filter results by
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [string]
        $FileName,

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
        $functionPath = "/wiki/rest/api/content/$ContentId/child/attachment"
        $verb = "GET"

        $query = New-PACRestMethodQueryParams @{
            start = $StartAt
            limit = $MaxResults
        }
        if($PSBoundParameters.ContainsKey("MediaType")){$query.Add("mediaType",$MediaType)}
        if($PSBoundParameters.ContainsKey("FileName")){$query.Add("filename",$FileName)}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}

        $method = New-PACRestMethod $functionPath $verb $query
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}
