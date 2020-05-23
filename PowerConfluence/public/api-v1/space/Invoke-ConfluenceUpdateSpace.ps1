#https://developer.atlassian.com/cloud/confluence/rest/#api-space-put
function Invoke-ConfluenceUpdateSpace {
    [CmdletBinding()]
    param (
        # The key of the new space
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [Alias("SpaceKey")]
        [string]
        $Key,

        # The name of the space
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [ValidateLength(1,200)]
        [string]
        $Name,

        # Description of the space
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [string]
        $Description,

        # ID of a page to set as the home page
        [Parameter(Position=3)]
        [int32]
        $HomepageId,

        # The AtlassianContext object to use for the request (use New-AtlassianContext)
        [Parameter()]
        [object]
        $RequestContext
    )
    begin {
        $results = @()
    }
    process {
        $functionPath = "/wiki/rest/api/space/$Key"
        $verb = "PUT"

        $body = New-PACRestMethodJsonBody @{}
        if($PSBoundParameters.ContainsKey("Name")){$body.Add("name",$Name)}
        if($PSBoundParameters.ContainsKey("Description")){$body.Add("description",@{plain=@{value=$Description;representation="plain"}})}
        if($PSBoundParameters.ContainsKey("HomepageId")){$body.Add("homepage",@{id=$HomepageId})}

        $method = New-PACRestMethod $functionPath $verb $null $body
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}