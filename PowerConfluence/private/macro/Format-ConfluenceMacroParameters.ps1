function Format-ConfluenceMacroParameters($Parameters=@{}) {
    $toReturn = @()
    foreach($key in $Parameters.Keys) {
        $toReturn += $global:PowerConfluence.Templates.Macro.ParameterTemplate -f $key,$Parameters.Item($key)
    }
    $toReturn
}