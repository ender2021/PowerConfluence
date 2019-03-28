function Format-ConfluenceAutomatedSection($GeneratedContent,$SectionType=$global:PowerConfluence.Templates.Layout.SectionDefaultType) {
    $contents = (Format-AutomationWarning) + $GeneratedContent + (Format-ConfluenceHtml -Tag "hr")
    Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $contents) -Type $SectionType
}