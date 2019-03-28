function Format-ConfluencePageLink($TargetPageTitle,$LinkText) {
    $global:PowerConfluence.Templates.Formatting.PageLinkTemplate -f "$TargetPageTitle","$LinkText"
}