###########################
# useful string libraries #
###########################

$PC_ConfluenceTemplates = @{
    Layout = @{
        LayoutTemplate = '<ac:layout>{0}</ac:layout>'
        SectionTemplate = '<ac:layout-section ac:type="{0}"><ac:layout-cell>{1}</ac:layout-cell></ac:layout-section>'
        SectionStart = '<ac:layout-section ac:type="single"><ac:layout-cell>'
        SectionEnd = '</ac:layout-cell></ac:layout-section>'
        SectionDefaultType = 'single'
    }
    Macro = @{
        MacroTemplate = '<ac:structured-macro ac:name="{0}" ac:schema-version="{1}">{2}</ac:structured-macro>'
        ParameterTemplate = '<ac:parameter ac:name="{0}">{1}</ac:parameter>'
        RichTextBodyTemplate = '<ac:rich-text-body>{0}</ac:rich-text-body>'
    }
    Formatting = @{
        DateTemplate = '<div class="content-wrapper"><time datetime="{0}" />&nbsp;</div>'
        IconTemplate = '<ac:emoticon ac:name="{0}" />'
        PageLinkTemplate = '<ac:link><ri:page ri:content-title="{0}" /><ac:plain-text-link-body><![CDATA[{1}]]></ac:plain-text-link-body></ac:link>'
    }
    Html = @{
        RelativeTable = '<table class="relative-table"><tbody>{0}</tbody></table>'
    }
}

$PC_ConfluenceMacros = @{
    Note = @{
        Name = "note"
        SchemaVersion = "1"
        ID = "2ce6d469-47d0-432c-a63d-88460de465cc"
    }
    Tip = @{
        Name = "tip"
        SchemaVersion = "1"
        ID = "cd81b82e-268c-47c2-ae41-a81a266f04ff"
    }
    Info = @{
        Name = "info"
        SchemaVersion = "1"
        ID = "ff3ceaa7-9121-4091-91ed-07131dea988f"
    }
    PageProperties = @{
        Name = "details"
        SchemaVersion = "1"
        ID = "4d43041c-1fb8-4349-90ca-7f30400b5d35"
    }
    PagePropertiesReport = @{
        Name = "detailssummary"
        SchemaVersion = "2"
        ID = "672a064c-4705-4b13-94a6-c4699cae8c24"
    }
    
}

########################################
# Confluence content rendering support #
########################################

function Format-ConfluencePagePropertiesReportMacro($Cql,$PageSize,$FirstColumn="",$Headings="",$SortBy="") {
    $params = @{
        cql = $Cql
        pageSize = $PageSize
    }
    if ($FirstColumn -ne "") {$params.Add("firstcolumn",$FirstColumn)}
    if ($Headings -ne "") {$params.Add("headings",$Headings)}
    if ($SortBy -ne "") {$params.Add("sortBy",$SortBy)}
	
    $macro = $PC_ConfluenceMacros.PagePropertiesReport
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -ID $macro.ID -Contents (Format-ConfluenceMacroParameters -Parameters $params)
}

function Format-ConfluenceLayout($Contents) {
    $PC_ConfluenceTemplates.Layout.LayoutTemplate -f "$Contents"
}

function Format-ConfluenceSection($Contents,$Type=$PC_ConfluenceTemplates.Layout.SectionDefaultType) {
    $PC_ConfluenceTemplates.Layout.SectionTemplate -f "$Type","$Contents"
}

function Format-ConfluenceMacro($Name,$SchemaVersion,$ID,$Contents) {
    $PC_ConfluenceTemplates.Macro.MacroTemplate -f $Name,$SchemaVersion,"$Contents"
}

function Format-ConfluenceMacroParameters($Parameters=@{}) {
    $toReturn = @()
    $Parameters.Keys | ForEach-Object -Process {$toReturn += $PC_ConfluenceTemplates.Macro.ParameterTemplate -f $_,$Parameters.Item($_)}
    $toReturn
}

function Format-ConfluenceMacroRichTextBody($Content) {
    $PC_ConfluenceTemplates.Macro.RichTextBodyTemplate -f "$Content"
}

function Format-ConfluenceDate($DateTime) {
    $PC_ConfluenceTemplates.Formatting.DateTemplate -f $DateTime.ToString("yyyy-MM-dd")
}

function Format-ConfluenceIcon($IconName) {
    $PC_ConfluenceTemplates.Formatting.IconTemplate -f "$IconName"
}

function Format-ConfluencePageLink($TargetPageTitle,$LinkText) {
    $PC_ConfluenceTemplates.Formatting.PageLinkTemplate -f "$TargetPageTitle","$LinkText"
}

function Format-ConfluenceDefaultUserSection() {
    # build the content
    $sectionContents = @()
    
    # section header
    $sectionContents += (Format-SimpleHtml -Tag "h1" -Contents "Additional Notes")
    
    # build the tip macro
    $macro = $PC_ConfluenceMacros.Tip
    $macroContents = @()
    $macroContents += (Format-ConfluenceMacroParameters -Parameters @{title="Editable Section"})
    $macroContents += (Format-ConfluenceMacroRichTextBody -Content (Format-SimpleHtml -Tag "p" -Contents "You may edit anything below this panel!"))
    $sectionContents += (Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -ID $macro.ID -Contents $macroContents)
    
    # section body
    $sectionContents += (Format-SimpleHtml -Tag "p" -Contents "No notes yet!")
    
    # done
    Format-ConfluenceSection -Contents $sectionContents
}
Format-ConfluenceDefaultUserSection
function Format-SimpleHtml($Tag,$Contents="") {
    (&{if($Contents -ne ""){"<$Tag>$Contents</$Tag>"}else{"<$Tag />"}})
}

function Format-HtmlTable($Rows) {
    $PC_ConfluenceTemplates.Html.RelativeTable -f "$Rows"
}

function Format-HtmlTableRow($Cells) {
    $cellTags = @()
    foreach ($cell in $Cells) {$cellTags += "<{0}{2}>{1}</{0}>" -f (""+$cell.Type),(""+$cell.Contents),(&{if($cell.Center){' style="text-align: center;"'}else{''}})}
    "<tr>$cellTags</tr>"
}

function Format-AutomationWarning() {
    $param = Format-ConfluenceMacroParameters -Parameters @{title="Automated Documentation"}
    $body = Format-ConfluenceMacroRichTextBody -Content (Format-SimpleHtml -Tag "p" -Contents "This page is automatically generated.&nbsp; Do not edit anything other than the marked section, or your changes may be lost!")
    $macro = $PC_ConfluenceMacros.Note
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -ID $macro.ID -Contents "$param$body"
}

function Format-ConfluencePageBase($GeneratedContent, $UserSection) {
    $generatedSection = Format-ConfluenceSection -Contents ((Format-AutomationWarning) + $GeneratedContent + (Format-SimpleHtml -Tag "hr"))
    Format-ConfluenceLayout -Contents "$generatedSection$UserSection"
}

function Format-ConfluencePagePropertiesBase($Properties) {
    $propertyRows = @()
    foreach ($prop in $Properties) {
        $propertyRows += (Format-HtmlTableRow -Cells (@{Type="th";Contents=$prop.Keys[0]},@{Type="td";Contents=$prop.Values[0]}))
    }

    # build the macro
    $macro = $PC_ConfluenceMacros.PageProperties
    $propTable = (Format-HtmlTable -Rows $propertyRows)
    $propMacro = Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroRichTextBody -Content $propTable)

    # return
    (Format-SimpleHtml -Tag "h1" -Contents "Properties") + $propMacro
}

Export-ModuleMember -Function * -Variable *