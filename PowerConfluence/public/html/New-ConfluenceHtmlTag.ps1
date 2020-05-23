function New-ConfluenceHtmlTag {
    [CmdletBinding()]
    param (
        # Tag
        [Parameter(Mandatory,Position=0)]
        [string]
        $Tag,

        # Contents
        [Parameter(Position=1)]
        [string]
        $Contents
    )
    
    begin {
        
    }
    
    process {
        New-Object ConfluenceHtmlTag @($Tag,$Contents)
    }
    
    end {
        
    }
}