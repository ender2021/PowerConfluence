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
        $functionPath = "/wiki/rest/api/space"
        $verb = "POST"

        $query = New-PACRestMethodQueryParams @{
            start = $StartAt
            limit = $MaxResults
        }

        $body = New-RestMethodJsonBody @{
            key = $Key
            name = $Name
        }
        if($PSBoundParameters.ContainsKey("Description")){$body.Add("description",@{plain=@{value=$Description;representation="plain"}})}
        #if($PSBoundParameters.ContainsKey("Permissions")){$body.Add("permissions",$Permissions)}

        $method = New-PACRestMethod $functionPath $verb $query $body
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}