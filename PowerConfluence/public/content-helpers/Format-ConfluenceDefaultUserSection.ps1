function Format-ConfluenceDefaultUserSection() {
    # build the content
    $sectionContents = @()
    
    # section header
    $sectionContents += (New-ConfluenceHtmlTag -Tag "h1" -Contents "Additional Notes").ToString()
    
    # build the tip macro
    $title = "Editable Section"
    $body = (New-ConfluenceHtmlTag -Tag "p" -Contents "You may edit anything below this panel!").ToString()

    $sectionContents += Format-ConfluenceMessageBoxMacro (Get-ConfluenceMessageBoxTypes).Tip $body $title
    
    # section body
    $sectionContents += (New-ConfluenceHtmlTag -Tag "p" -Contents "No notes yet!").ToString()
    
    # done
    Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $sectionContents)
}