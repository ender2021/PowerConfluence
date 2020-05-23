function New-ConfluenceHtmlTableRow {
    [CmdletBinding()]
    param (
        # Cells
        [Parameter(Position=0)]
        [object[]]
        $Cells,

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
        New-Object ConfluenceHtmlTableRow @($Cells,$Header,$Center)
    }
    
    end {
        
    }
}