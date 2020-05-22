function Format-AutomationWarning {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        $title = "Automated Documentation"
        $body = Format-ConfluenceHtml -Tag "p" -Contents "This page is automatically generated.&nbsp; Do not edit anything other than the marked section, or your changes may be lost!"
    
        Format-ConfluenceMessageBoxMacro (Get-ConfluenceMessageBoxTypes).Note $body $title
    }
    
    end {
        
    }
}