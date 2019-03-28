function Format-ConfluenceAutomatedCell($GeneratedContent) {
    $contents = (Format-AutomationWarning) + $GeneratedContent
    Format-ConfluenceCell -Contents $contents
}