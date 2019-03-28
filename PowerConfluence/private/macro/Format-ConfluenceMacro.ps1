function Format-ConfluenceMacro($Name,$SchemaVersion,$Contents) {
    $global:PowerConfluence.Templates.Macro.MacroTemplate -f $Name,$SchemaVersion,"$Contents"
}