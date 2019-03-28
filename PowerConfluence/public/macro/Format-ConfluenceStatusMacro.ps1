function Format-ConfluenceStatusMacro($Color,$Text,[switch]$OutlineStyle)
{
    $params = @{
        colour = $Color
        title = $Text
    }
    if ($OutlineStyle) {$params.Add("subtle","true")}
    
    $macro = $global:PowerConfluence.Macros.Status
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroParameters -Parameters $params)
}