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

        # The ConfluenceConnection object to use for the request
        [Parameter(Position=4)]
        [hashtable]
        $ConfluenceConnection
    )
    begin {
        $results = @()
    }
    process {
        $RestArgs = @{
            ConfluenceConnection = $ConfluenceConnection
            FunctionPath = "/wiki/rest/api/space/$Key"
            HttpMethod = "PUT"
            Body = @{}
        }
        if($PSBoundParameters.ContainsKey("Name")){$RestArgs.Body.Add("name",$Name)}
        if($PSBoundParameters.ContainsKey("Description")){$RestArgs.Body.Add("description",@{plain=@{value=$Description;representation="plain"}})}
        if($PSBoundParameters.ContainsKey("HomepageId")){$RestArgs.Body.Add("homepage",@{id=$HomepageId})}

        $results += Invoke-ConfluenceRestMethod @RestArgs
    }
    end {
        $results
    }
}