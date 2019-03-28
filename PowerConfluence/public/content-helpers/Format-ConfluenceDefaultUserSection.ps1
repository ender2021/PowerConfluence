function Format-ConfluenceDefaultUserSection() {
    # build the content
    $sectionContents = @()
    
    # section header
    $sectionContents += (Format-ConfluenceHtml -Tag "h1" -Contents "Additional Notes")
    
    # build the tip macro
    $macro = $global:PowerConfluence.Macros.Tip
    $macroContents = @()
    $macroContents += (Format-ConfluenceMacroParameters -Parameters @{title="Editable Section"})
    $macroContents += (Format-ConfluenceMacroRichTextBody -Content (Format-ConfluenceHtml -Tag "p" -Contents "You may edit anything below this panel!"))
    $sectionContents += (Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents $macroContents)

    # section body
    $sectionContents += (Format-ConfluenceHtml -Tag "p" -Contents "No notes yet!")
    
    # done
    Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $sectionContents)
}