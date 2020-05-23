function Format-ConfluenceAutomatedSection($GeneratedContent,$SectionType=$global:PowerConfluence.Templates.Layout.SectionDefaultType) {
    $contents = (Format-AutomationWarning) + $GeneratedContent + (New-ConfluenceHtmlTag -Tag "hr").ToString()
    Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $contents) -Type $SectionType
}