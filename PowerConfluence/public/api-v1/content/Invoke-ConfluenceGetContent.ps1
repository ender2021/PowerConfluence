$ConfluenceContentExpand = @("childTypes.all","childTypes.attachment","childTypes.comment","childTypes.page",
                             "container","metadata.currentuser","metadata.properties","metadata.labels",
                             "metadata.frontend","operations","children.page","children.attachment","children.comment",
                             "restrictions.read.restrictions.user","restrictions.read.restrictions.group",
                             "restrictions.update.restrictions.user","restrictions.update.restrictions.group",
                             "history","history.lastUpdated","history.previousVersion","history.contributors",
                             "history.nextVersion","ancestors","body","version","descendants.page",
                             "descendants.attachment","descendants.comment","space")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-get
function Invoke-ConfluenceGetContent {
    [CmdletBinding(DefaultParameterSetName="Page")]
    param (
        # The title of the content to search for
        [Parameter(Mandatory,Position=0,ParameterSetName="Page",ValueFromPipelineByPropertyName)]
        [Parameter(Position=0,ParameterSetName="Blog",ValueFromPipelineByPropertyName)]
        [string]
        $Title,

        # Space key of the space to return content from
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [string]
        $SpaceKey,

        # The title of the content to search for
        [Parameter(Position=2,ParameterSetName="Page",ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory,Position=2,ParameterSetName="Blog",ValueFromPipelineByPropertyName)]
        [datetime]
        $PostDate,

        # The index of the first item to return in the page of results (page offset). The base index is 0.
        [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        [int32]
        $StartAt=0,

        # The maximum number of items to return per page. The default is 25 and the maximum is 100.
        [Parameter(Position=4,ValueFromPipelineByPropertyName)]
        [ValidateRange(1,100)]
        [int32]
        $MaxResults=25,

        # How to order the results
        [Parameter(Position=5,ValueFromPipelineByPropertyName)]
        [string]
        $OrderBy,

        # Used to expand additional attributes
        [Parameter(Position=6,ValueFromPipelineByPropertyName)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceContentExpand $_ })]
        [string[]]
        $Expand,

        # Set this flag to return all content regardless of status
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $AllStatuses,

        # Set this flag to triggered the "viewed" event for the content
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $TriggerView,

        # Set this flag to return blog posts instead of pages
        [Parameter(Mandatory,ParameterSetName="Blog",ValueFromPipelineByPropertyName)]
        [switch]
        $Blog,

        #Set this flag to return page type posts (not necessary, as this is the default behavior)
        [Parameter(ParameterSetName="Page",ValueFromPipelineByPropertyName)]
        [switch]
        $Page,

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
        $verb = "GET"

        $query=@{
            type = IIF $Blog "blogpost" "page"
            status = (IIF $AllStatuses "any" "current")
            start = $StartAt
            limit = $MaxResults
        }
        if($PSBoundParameters.ContainsKey("Title")){$query.Add("title",$Title)}
        if($PSBoundParameters.ContainsKey("SpaceKey")){$query.Add("spaceKey",$SpaceKey)}
        if($PSBoundParameters.ContainsKey("PostDate")){$query.Add("postingDay",($PostDate -f "yyyy-MM-dd"))}
        if($PSBoundParameters.ContainsKey("Expand")){$query.Add("expand",$Expand -join ",")}
        if($PSBoundParameters.ContainsKey("OrderBy")){$query.Add("orderBy",$OrderBy)}
        if($TriggerView) {$query.Add("trigger","viewed")}

        $results += Invoke-ConfluenceRestMethod $ConfluenceConnection $functionPath $verb -Query $query
    }
    end {
        $results
    }
}