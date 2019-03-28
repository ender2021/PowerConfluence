function Format-ConfluenceHtmlTableCell($Type,$Contents,$Center=$false) {
    $toReturn = @{Type="$Type";Contents="$Contents"}
    if ($Center) {$toReturn.Add("Center",$true)}
    $toReturn
}