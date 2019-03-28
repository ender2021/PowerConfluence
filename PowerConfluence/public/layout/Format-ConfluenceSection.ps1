function Format-ConfluenceSection($Contents,$Type=$global:PowerConfluence.Templates.Layout.SectionDefaultType) {
    $global:PowerConfluence.Templates.Layout.SectionTemplate -f "$Type","$Contents"
}