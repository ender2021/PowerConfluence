function Format-ConfluenceDate($DateTime) {
    $global:PowerConfluence.Templates.Formatting.DateTemplate -f $DateTime.ToString("yyyy-MM-dd")
}