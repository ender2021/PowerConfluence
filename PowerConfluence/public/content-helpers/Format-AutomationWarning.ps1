function Format-AutomationWarning() {
    $param = Format-ConfluenceMacroParameters -Parameters @{title="Automated Documentation"}
    $body = Format-ConfluenceMacroRichTextBody -Content (Format-ConfluenceHtml -Tag "p" -Contents "This page is automatically generated.&nbsp; Do not edit anything other than the marked section, or your changes may be lost!")
    $macro = $global:PowerConfluence.Macros.Note
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents "$param$body"
}