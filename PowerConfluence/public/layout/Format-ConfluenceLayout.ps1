function Format-ConfluenceLayout($Contents) {
    $global:PowerConfluence.Templates.Layout.LayoutTemplate -f "$Contents"
}