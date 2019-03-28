function Format-ConfluenceCell($Contents) {
    $global:PowerConfluence.Templates.Layout.CellTemplate -f "$Contents"
}