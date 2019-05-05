function New-ConfluenceContentBody {
    [CmdletBinding()]
    param (
        # String body content in a Confluence format
        [Parameter(Mandatory,Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [AllowEmptyString()]
        [string]
        $Body,

        # The format of the body
        [Parameter(Position=1,ValueFromPipelineByPropertyName)]
        [ValidateSet("view","export_view","styled_view","storage")]
        [string]
        $Format="storage"
    )
    begin {
        $results = @()
    }
    process {
        $results += [PSCustomObject]@{
            $Format = [PSCustomObject]@{
                representation = $Format
                value = $Body
            }
        }
    }
    end {
        $results
    }
}