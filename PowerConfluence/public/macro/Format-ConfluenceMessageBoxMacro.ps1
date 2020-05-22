function Format-ConfluenceMessageBoxMacro {
    [CmdletBinding()]
    param (
        # Type
        [Parameter(Mandatory,Position=0)]
        [ValidateSet("tip","info","note")]
        [string]
        $Type,

        # Message body
        [Parameter(Mandatory,Position=1)]
        [string]
        $MessageBody,

        # Title
        [Parameter(Position=2)]
        [string]
        $Title,

        # Hide icon flag
        [Parameter(Position=3)]
        [switch]
        $HideIcon
    )
    
    begin {
        
    }
    
    process {
        (New-Object PowerConfluenceMessageBoxMacro @($Type, $MessageBody, $Title, !$HideIcon)).Render()
    }
    
    end {
        
    }
}