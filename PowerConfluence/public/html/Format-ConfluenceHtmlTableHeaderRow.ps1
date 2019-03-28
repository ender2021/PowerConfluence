function Format-ConfluenceHtmlTableHeaderRow($Headers=@(),$Center) {
    $cells = @()
    foreach ($h in $Headers) {$cells += (New-ConfluenceHtmlTableCell -Type "th" -Contents $h -Center $Center)}
    Format-ConfluenceHtmlTableRow -Cells $cells
}