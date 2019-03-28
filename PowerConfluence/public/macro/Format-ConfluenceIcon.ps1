function Format-ConfluenceIcon($Icon) {
    if ($Icon -eq $null) {
        $name = $global:PowerConfluence.Emoticons.Question
    } else {
        $name = (&{if ($Icon.GetType().Name -eq "Boolean") {(&{If($Icon) {$global:PowerConfluence.Emoticons.Tick} Else {$global:PowerConfluence.Emoticons.Cross}})} else {$Icon}})
    }
    $global:PowerConfluence.Templates.Formatting.IconTemplate -f "$name"
}