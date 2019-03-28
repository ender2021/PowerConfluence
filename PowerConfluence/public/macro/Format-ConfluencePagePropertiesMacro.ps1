function Format-ConfluencePagePropertiesMacro($Properties) {
    $propertyRows = @()
    foreach ($prop in $Properties) {
        $propertyRows += (Format-ConfluenceHtmlTableRow -Cells (@{Type="th";Contents=$prop.Keys[0]},@{Type="td";Contents=$prop.Values[0]}))
    }

    # build the macro
    $macro = $global:PowerConfluence.Macros.PageProperties
    $propTable = (Format-ConfluenceHtmlTable -Rows $propertyRows)

    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroRichTextBody -Content $propTable)
}