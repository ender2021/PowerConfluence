function Format-ConfluenceStatusMacro {
    [CmdletBinding()]
    param (
        # Color to make the macro
        [Parameter(Mandatory,Position=0)]
        [string]
        $Color,

        # The text to display
        [Parameter(Mandatory,Position=1)]
        [string]
        $Text,

        # Set this flag to use outline style instead of the filled in style
        [Parameter()]
        [switch]
        $OutlineStyle
    )
    
    begin {
        
    }
    
    process {
        (New-Object PowerConfluenceStatusMacro @($Color,$Text,$OutlineStyle)).ToString()
    }
    
    end {
        
    }
}