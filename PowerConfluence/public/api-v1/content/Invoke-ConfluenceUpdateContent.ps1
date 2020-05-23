#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-put
function Invoke-ConfluenceUpdateContent {
    [CmdletBinding(DefaultParameterSetName="VersionObject")]
    param (
        # The ID of the content to update
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [Alias("ContentId")]
        [int32]
        $Id,

        # The current version of the content
        [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName,ParameterSetName="VersionNumber")]
        [int32]
        $VersionNum,

        # The current version of the content
        [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName,ParameterSetName="VersionObject")]
        [Alias("Version")]
        [ValidateScript({ $_.PSobject.Properties.Name -contains "number" })]
        [object]
        $VersionObj,
        

        # The title of the content
        [Parameter(Mandatory,Position=2,ValueFromPipelineByPropertyName)]
        [ValidateLength(1,255)]
        [string]
        $Title,

        # The body of the content.  Use New-ConfluenceContentBody
        [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        [Alias("Body")]
        [pscustomobject]
        $ContentBody,

        # The ID of the content parent
        [Parameter(Position=4,ValueFromPipelineByPropertyName)]
        [int32]
        $ParentId,

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

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/content/$Id"
        $verb = "PUT"

        $version = IIF ($PSCmdlet.ParameterSetName -eq "VersionNumber") $VersionNum $VersionObj.number

        $body = New-PACRestMethodJsonBody @{
            type = $Type
            title = $Title
            status = $Status
            version = @{number=(IIF ($Status -eq "draft") 1 ($version + 1))}
        }
        if($PSBoundParameters.ContainsKey("ContentBody")){$body.Add("body",$ContentBody)}
        if($PSBoundParameters.ContainsKey("ParentId")){$body.Add("ancestors",@{id=$ParentId})}

        $method = New-PACRestMethod $functionPath $verb $null $body
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}