$ConfluenceChildExpand = @("attachment","comments","page")

#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-child-get
function Invoke-ConfluenceGetContentChildren {
    [CmdletBinding()]
    param (
        # The ID of the content to delete
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # The current version of the content
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [int32]
        $CurrentVersion,

        # Used to expand additional attributes
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [ValidateScript({ Compare-StringArraySubset $ConfluenceChildExpand $_ })]
        [string[]]
        $Expand,

        # The ConfluenceConnection object to use for the request
        [Parameter()]
        [hashtable]
        $ConfluenceConnection
    )
    begin {
        $results = @()
    }
    process {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/content/$ContentId/child"
            HttpMethod = "GET"
            Query = @{}
        }
        if($PSBoundParameters.ContainsKey("Expand")){$RestArgs.Query.Add("expand",$Expand -join ",")}
        if($PSBoundParameters.ContainsKey("CurrentVersion")){$RestArgs.Query.Add("parentVersion",$CurrentVersion)}

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}