function Format-ConfluenceHtmlTable($Rows) {
    $global:PowerConfluence.Templates.Html.RelativeTable -f "$Rows"
}