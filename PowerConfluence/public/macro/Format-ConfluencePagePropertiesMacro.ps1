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
            $propertyRows += (Format-ConfluenceHtmlTableRow -Cells (@{Type="th";Contents=$prop.Keys[0]},@{Type="td";Contents=$prop.Values[0]}))
        }
        $propTable = (Format-ConfluenceHtmlTable -Rows $propertyRows)

        (New-Object PowerConfluencePagePropertiesMacro @($propTable)).Render()
    }
    
    end {
        
    }
}