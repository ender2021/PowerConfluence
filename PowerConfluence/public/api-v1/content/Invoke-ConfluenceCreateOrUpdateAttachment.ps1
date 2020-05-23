#https://developer.atlassian.com/cloud/confluence/rest/#api-content-id-child-attachment-post
function Invoke-ConfluenceCreateOrUpdateAttachment {
    [CmdletBinding()]
    param (
        # The ID of the content to create an attachment for
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [int32]
        $ContentId,

        # The file to be added
        [Parameter(Mandatory,Position=1,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [object]
        $Attachment,

        # A comment to go with the attachment
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [string]
        $Comment,

        # The status of the content that the attachment is to be added to
        [Parameter(Position=3,ValueFromPipelineByPropertyName)]
        [ValidateSet("current","draft")]
        [string]
        $Status="current",

        # Set this flag to indicate that this change should not trigger notifications or activity feed updates
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $MinorEdit,

        # Set this flag to force a create, throwing an error if the attachment already exists
        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $ForceCreate,

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
        $verb = IIF $ForceCreate "POST" "PUT"

        $query = New-PACRestMethodQueryParams @{
            status = $Status
        }

        $body = @{
            file = $Attachment
            minorEdit = $MinorEdit
        }
        if($PSBoundParameters.ContainsKey("Comment")){$body.Add("comment",$Comment)}

        $method = New-PACRestMethod $functionPath $verb $query $body
        $results += $method.Invoke($RequestContext)
    }
    end {
        $results
    }
}