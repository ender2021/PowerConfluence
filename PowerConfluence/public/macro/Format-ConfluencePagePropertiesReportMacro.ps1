function Format-ConfluencePagePropertiesReportMacro {
    [CmdletBinding()]
    param (
        # Cql
        [Parameter(Mandatory,Position=0)]
        [string]
        $Cql,

        # Page size
        [Parameter(Position=1)]
        [int]
        $PageSize = 30,

        # First column
        [Parameter(Position=2)]
        [string]
        $FirstColumn,

        # Headings
        [Parameter(Position=3)]
        [string]
        $Headings,

        # Sort by
        [Parameter(Position=4)]
        [string]
        $SortBy
    )
    
    begin {
        
    }
    
    process {
        (New-Object PowerConfluencePagePropertiesReportMacro @($Cql,$PageSize,$FirstColumn,$Headings,$SortBy)).Render()
    }
    
    end {
        
    }
}