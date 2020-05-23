function New-ConfluenceHtmlTableCell {
    [CmdletBinding()]
    param (
        # Contents
        [Parameter(Position=0)]
        [string]
        $Contents,

        # Header
        [Parameter(Position=1)]
        [switch]
        $Header,

        # Center
        [Parameter(Position=2)]
        [switch]
        $Center
    )
    
    begin {
        
    }
    
    process {
        New-Object ConfluenceHtmlTableCell @($Contents,$Header,$Center)
    }
    
    end {
        
    }
}