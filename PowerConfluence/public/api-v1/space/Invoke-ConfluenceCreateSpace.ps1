#https://developer.atlassian.com/cloud/confluence/rest/#api-space-post
function Invoke-ConfluenceCreateSpace {
    [CmdletBinding()]
    param (
        # The key of the new space
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [Alias("SpaceKey")]
        [string]
        $Key,

        # The name of the space
        [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName)]
        [ValidateLength(1,200)]
        [string]
        $Name,

        # Description of the space
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [string]
        $Description,

        # # Permissions to associate with the space
        # [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        # [pscustomobject[]]
        # $Permissions,

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
            FunctionPath = "/wiki/rest/api/space"
            HttpMethod = "POST"
            Body = @{
                key = $Key
                name = $Name
            }
        }
        if($PSBoundParameters.ContainsKey("Description")){$RestArgs.Body.Add("description",@{plain=@{value=$Description;representation="plain"}})}
        #if($PSBoundParameters.ContainsKey("Permissions")){$RestArgs.Body.Add("permissions",$Permissions)}

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}