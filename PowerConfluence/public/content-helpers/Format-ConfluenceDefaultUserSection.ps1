function Format-ConfluenceDefaultUserSection() {
    # build the content
    $sectionContents = @()
    
    # section header
    $sectionContents += (Format-ConfluenceHtml -Tag "h1" -Contents "Additional Notes")
    
    # build the tip macro
    $title = "Editable Section"
    $body = Format-ConfluenceHtml -Tag "p" -Contents "You may edit anything below this panel!"

    $sectionContents += Format-ConfluenceMessageBoxMacro (Get-ConfluenceMessageBoxTypes).Tip $body $title
    
    # section body
    $sectionContents += (Format-ConfluenceHtml -Tag "p" -Contents "No notes yet!")
    
    # done
    Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $sectionContents)
}