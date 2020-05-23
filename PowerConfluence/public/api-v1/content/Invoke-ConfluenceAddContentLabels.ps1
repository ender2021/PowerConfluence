#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-label-post
function Invoke-ConfluenceAddContentLabels {
    [CmdletBinding()]
    param (
        # The ID of the page
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("PageId")]
        [int32]
        $Id,

        # The name of the label to add
        [Parameter(Mandatory,Position=1,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string[]]
        $Label,

        # The scope of the label
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [ValidateSet("global","my","team")]
        [string]
        $Scope="global",

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/content/$Id/label"
        $verb = "POST"

        $body = @()
        $Label | ForEach-Object { $body += @{name = $_; prefix = $Scope} }
            
        $literalBody = ConvertTo-Json $body -Compress

        $results += Invoke-ConfluenceRestMethod $ConfluenceConnection $functionPath $verb -LiteralBody $literalBody
    }
    end {
        $results
    }
}