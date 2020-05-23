function New-ConfluenceHtmlTable {
    [CmdletBinding()]
    param (
        # Rows
        [Parameter(Position=0)]
        [object[]]
        $Rows,

        # Center
        [Parameter(Position=1)]
        [switch]
        $Center
    )
    
    begin {
        
    }
    
    process {
        New-Object ConfluenceHtmlTable @($Rows,$Center)
    }
    
    end {
        
    }
}