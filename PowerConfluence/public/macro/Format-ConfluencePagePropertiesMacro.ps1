function Format-ConfluencePagePropertiesMacro {
    [CmdletBinding()]
    param (
        # Page properties
        [Parameter(Mandatory,Position=0)]
        [hashtable]
        $Properties
    )
    
    begin {
        
    }
    
    process {
        $propertyRows = @()
        foreach ($prop in $Properties) {
            $cells = @(
                New-ConfluenceHtmlTableCell -Contents $prop.Keys[0] -Header
                New-ConfluenceHtmlTableCell -Contents $prop.Value[0]
            )
            $propertyRows += New-ConfluenceHtmlTableRow -Cells $Cells
        }
        $propTable = (New-ConfluenceHtmlTable -Rows $propertyRows).ToString()

        (New-Object PowerConfluencePagePropertiesMacro @($propTable)).ToString()
    }
    
    end {
        
    }
}