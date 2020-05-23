$ConfluenceSpaceExpand = @("settings","metadata.labels","operations","lookAndFeel"
                           "permissions","icon","description.plain","description.view"
                           "theme","homepage")

#https://developer.atlassian.com/cloud/confluence/rest/#api-settings-theme-themeKey-get
function Invoke-ConfluenceGetSpaces {
    [CmdletBinding()]
    param (
        # Space keys of specific spaces to return
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Key","Keys")]
        [string[]]
        $SpaceKeys,

        # Filter results by the provided type
        [Parameter(Position=1)]
        [ValidateSet("global","personal")]
        [string]
        $Type,

        # Filter results by the provide status
        [Parameter(Position=2)]
        [ValidateSet("current","archived")]
        [string]
        $Status,

        # Filter results by labels
        [Parameter(Position=3)]
        [string[]]
        $Labels,

        # Filter by this user's favourites (if not provided, the favourite filter will act on the current user)
        [Parameter(Position=4)]
        [string]
        $FavouriteUserKey,

        # The index of the first item to return in the page of results (page offset). The base index is 0.
        [Parameter(Position=5)]
        [int32]
        $StartAt=0,

        # The maximum number of items to return per page. The default is 25 and the maximum is 100.
        [Parameter(Position=6)]
        [ValidateRange(1,100)]
        [int32]
        $MaxResults=25,

        # Used to expand additional attributes
        [Parameter(Position=7)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceSpaceExpand $_ })]
        [string[]]
        $Expand,

        # Filter results by favourites of a user
        [Parameter()]
        [switch]
        $Favourite,

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $keys = @()
    }
    process {
        if ($SpaceKeys.Count -gt 0) {
           $keys += $SpaceKeys | ForEach-Object {Format-QueryKvp "spaceKey" $_}
        }
    }
    end {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/space"
            HttpMethod = "GET"
            QueryKvp = @(
                Format-QueryKvp "start" $StartAt
                Format-QueryKvp "limit" $MaxResults
            )
        }
        if($keys.Count -gt 0) {$RestArgs.QueryKvp += $keys}
        if($PSBoundParameters.ContainsKey("Expand")){$RestArgs.QueryKvp += Format-QueryKvp "expand" ($Expand -join ",")}
        if($PSBoundParameters.ContainsKey("Type")){$RestArgs.QueryKvp += Format-QueryKvp "type" $Type}
        if($PSBoundParameters.ContainsKey("Status")){$RestArgs.QueryKvp += Format-QueryKvp "status" $Status}
        if($PSBoundParameters.ContainsKey("Labels")){$RestArgs.QueryKvp += Format-QueryKvp "label" ($Labels -join ",")}
        if($PSBoundParameters.ContainsKey("Favourite")){$RestArgs.QueryKvp += Format-QueryKvp "favourite" $Favourite}
        if($PSBoundParameters.ContainsKey("FavouriteUserKey")){$RestArgs.QueryKvp += Format-QueryKvp "favouriteUserKey" $FavouriteUserKey}

        Invoke-ConfluenceRestMethod @RestArgs
    }
}