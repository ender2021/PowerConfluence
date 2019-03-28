function Format-ConfluencePagePropertiesReportMacro($Cql,$PageSize,$FirstColumn="",$Headings="",$SortBy="") {
    $params = @{
        cql = $Cql
        pageSize = $PageSize
    }
    if ($FirstColumn -ne "") {$params.Add("firstcolumn",$FirstColumn)}
    if ($Headings -ne "") {$params.Add("headings",$Headings)}
    if ($SortBy -ne "") {$params.Add("sortBy",$SortBy)}
	
    $macro = $global:PowerConfluence.Macros.PagePropertiesReport
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroParameters -Parameters $params)
}