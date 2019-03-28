function Format-ConfluenceMacroRichTextBody($Content) {
    $global:PowerConfluence.Templates.Macro.RichTextBodyTemplate -f "$Content"
}