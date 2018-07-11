###########################
# useful string libraries #
###########################

$PC_ConfluenceEmoticons = @{
    Smile="smile"
    Sad="sad"
    Cheeky="cheeky"
    Laugh="laugh"
    Wink="wink"
    ThumbsUp="thumbs-up"
    ThumbsDown="thumbs-down"
    Info="information"
    Tick="tick"
    Cross="cross"
    Warning="warning"
    Plus="plus"
    Minus="minus"
    Question="question"
    BulbOn="light-on"
    BulbOff="light-off"
    StarYellow="yellow-star"
    StarRed="red-star"
    StarGreen="green-star"
    StarBlue="blue-star"
}

$PC_ConfluenceTemplates = @{
    Layout = @{
        LayoutTemplate = '<ac:layout>{0}</ac:layout>'
        SectionTemplate = '<ac:layout-section ac:type="{0}">{1}</ac:layout-section>'
        SectionStart = '<ac:layout-section ac:type="'
        SectionEnd = '</ac:layout-section>'
        CellTemplate = '<ac:layout-cell>{0}</ac:layout-cell>'
        CellStart = '<ac:layout-cell>'
        CellEnd = '</ac:layout-cell>'
        SectionDefaultType = 'single'
        UserSection = @{
            DefaultMap = @($false,$true) # the page has two single sections
            ComplexMap = @(@($true,$false),$true,$false) # the page has 3 sections, 1 w/ 1 custom cell and 1 autocell
        }
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
        TaskList = '<ac:task-list>{0}</ac:task-list>'
        Task = '<ac:task><ac:task-id>{0}</ac:task-id><ac:task-status>{1}</ac:task-status><ac:task-body><span class="placeholder-inline-tasks">{2}</span></ac:task-body></ac:task>'
    }
    Html = @{
        RelativeTable = '<table class="relative-table"><tbody>{0}</tbody></table>'
    }
}

$PC_ConfluenceMacros = @{
    Note = @{
        Name = "note"
        SchemaVersion = "1"
        Parameters = @{
            title=@{Default="";Required=$true}
            icon=@{Default=$true;Required=$false}
        }
        RichTextBody=$true
    }
    Tip = @{
        Name = "tip"
        SchemaVersion = "1"
        Parameters = @{
            title=@{Default="";Required=$true}
            icon=@{Default=$true;Required=$false}
        }
        RichTextBody=$true
    }
    Info = @{
        Name = "info"
        SchemaVersion = "1"
        Parameters = @{
            title=@{Default="";Required=$true}
            icon=@{Default=$true;Required=$false}
        }
        RichTextBody=$true
    }
    PageProperties = @{
        Name = "details"
        SchemaVersion = "1"
        Parameters = @{}
        RichTextBody=$true
    }
    PagePropertiesReport = @{
        Name = "detailssummary"
        SchemaVersion = "2"
        Parameters = @{
            firstcolumn=@{Default="";Required=$false}
            subtle=@{Default="";Required=$false}
            headings=@{Default="";Required=$false}
            sortBy=@{Default="";Required=$false}
            cql=@{Default="";Required=$true}
            pageSize=@{Default="30";Required=$true}
        }
        RichTextBody=$false
    }
    Status = @{
        Name = "status"
        SchemaVersion = 1
        Parameters = @{
            colour=@{Default="";Required=$true}
            title=@{Default="";Required=$true}
            subtle=@{Default=$false;Required=$false}
        }
        RichTextBody=$false
        Colors = @{
            Green="Green"
            Blue="Blue"
            Yellow="Yellow"
            Red="Red"
            Grey="Grey"
        }
    }
}

########################################
# Confluence content rendering support #
########################################

function Format-ConfluenceHtml($Tag,$Contents="") {
    (&{if($Contents -ne ""){"<$Tag>$Contents</$Tag>"}else{"<$Tag />"}})
}

function Format-ConfluenceHtmlTable($Rows) {
    $PC_ConfluenceTemplates.Html.RelativeTable -f "$Rows"
}

function Format-ConfluenceHtmlTableRow($Cells) {
    $cellTags = @()
    foreach ($cell in $Cells) {$cellTags += "<{0}{2}>{1}</{0}>" -f (""+$cell.Type),(""+$cell.Contents),(&{if($cell.Center){' style="text-align: center;"'}else{''}})}
    "<tr>$cellTags</tr>"
}

function Format-ConfluenceHtmlTableHeaderRow($Headers=@(),$Center) {
    $cells = @()
    foreach ($h in $Headers) {$cells += (New-ConfluenceHtmlTableCell -Type "th" -Contents $h -Center $Center)}
    Format-ConfluenceHtmlTableRow -Cells $cells
}

function New-ConfluenceHtmlTableCell($Type,$Contents,$Center=$false) {
    $toReturn = @{Type="$Type";Contents="$Contents"}
    if ($Center) {$toReturn.Add("Center",$true)}
    $toReturn
}

function Format-ConfluenceMacro($Name,$SchemaVersion,$Contents) {
    $PC_ConfluenceTemplates.Macro.MacroTemplate -f $Name,$SchemaVersion,"$Contents"
}

function Format-ConfluenceMacroParameters($Parameters=@{}) {
    $toReturn = @()
    foreach($key in $Parameters.Keys) {
        $toReturn += $PC_ConfluenceTemplates.Macro.ParameterTemplate -f $key,$Parameters.Item($key)
    }
    $toReturn
}

function Format-ConfluenceMacroRichTextBody($Content) {
    $PC_ConfluenceTemplates.Macro.RichTextBodyTemplate -f "$Content"
}

function Format-ConfluencePagePropertiesReportMacro($Cql,$PageSize,$FirstColumn="",$Headings="",$SortBy="") {
    $params = @{
        cql = $Cql
        pageSize = $PageSize
    }
    if ($FirstColumn -ne "") {$params.Add("firstcolumn",$FirstColumn)}
    if ($Headings -ne "") {$params.Add("headings",$Headings)}
    if ($SortBy -ne "") {$params.Add("sortBy",$SortBy)}
	
    $macro = $PC_ConfluenceMacros.PagePropertiesReport
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroParameters -Parameters $params)
}

function Format-ConfluenceStatusMacro($Color,$Text,[switch]$OutlineStyle)
{
    $params = @{
        colour = $Color
        title = $Text
    }
    if ($OutlineStyle) {$params.Add("subtle","true")}
    
    $macro = $PC_ConfluenceMacros.Status
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroParameters -Parameters $params)
}

function Format-ConfluenceLayout($Contents) {
    $PC_ConfluenceTemplates.Layout.LayoutTemplate -f "$Contents"
}

function Format-ConfluenceSection($Contents,$Type=$PC_ConfluenceTemplates.Layout.SectionDefaultType) {
    $PC_ConfluenceTemplates.Layout.SectionTemplate -f "$Type","$Contents"
}

function Format-ConfluenceCell($Contents) {
    $PC_ConfluenceTemplates.Layout.CellTemplate -f "$Contents"
}

function Format-ConfluenceDate($DateTime) {
    $PC_ConfluenceTemplates.Formatting.DateTemplate -f $DateTime.ToString("yyyy-MM-dd")
}

function Format-ConfluenceIcon($Icon) {
    $name = (&{if ($Icon.GetType().Name -eq "Boolean") {(&{If($Icon) {$PC_ConfluenceEmoticons.Tick} Else {$PC_ConfluenceEmoticons.Cross}})} else {$Icon}})
    $PC_ConfluenceTemplates.Formatting.IconTemplate -f "$name"
}

function Format-ConfluencePageLink($TargetPageTitle,$LinkText) {
    $PC_ConfluenceTemplates.Formatting.PageLinkTemplate -f "$TargetPageTitle","$LinkText"
}

function Format-ConfluenceDefaultUserSection() {
    # build the content
    $sectionContents = @()
    
    # section header
    $sectionContents += (Format-ConfluenceHtml -Tag "h1" -Contents "Additional Notes")
    
    # build the tip macro
    $macro = $PC_ConfluenceMacros.Tip
    $macroContents = @()
    $macroContents += (Format-ConfluenceMacroParameters -Parameters @{title="Editable Section"})
    $macroContents += (Format-ConfluenceMacroRichTextBody -Content (Format-ConfluenceHtml -Tag "p" -Contents "You may edit anything below this panel!"))
    $sectionContents += (Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents $macroContents)

    # section body
    $sectionContents += (Format-ConfluenceHtml -Tag "p" -Contents "No notes yet!")
    
    # done
    Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $sectionContents)
}

function Format-AutomationWarning() {
    $param = Format-ConfluenceMacroParameters -Parameters @{title="Automated Documentation"}
    $body = Format-ConfluenceMacroRichTextBody -Content (Format-ConfluenceHtml -Tag "p" -Contents "This page is automatically generated.&nbsp; Do not edit anything other than the marked section, or your changes may be lost!")
    $macro = $PC_ConfluenceMacros.Note
    Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents "$param$body"
}

function Format-ConfluencePageBase($GeneratedContent, $UserSection) {
    #TODO - update this function to accept a content array that combines generated and user content
    $contents = (Format-AutomationWarning) + $GeneratedContent + (Format-ConfluenceHtml -Tag "hr")
    $generatedSection = Format-ConfluenceSection -Contents (Format-ConfluenceCell -Contents $contents)
    Format-ConfluenceLayout -Contents "$generatedSection$UserSection"
}

function Format-ConfluencePagePropertiesBase($Properties) {
    $propertyRows = @()
    foreach ($prop in $Properties) {
        $propertyRows += (Format-ConfluenceHtmlTableRow -Cells (@{Type="th";Contents=$prop.Keys[0]},@{Type="td";Contents=$prop.Values[0]}))
    }

    # build the macro
    $macro = $PC_ConfluenceMacros.PageProperties
    $propTable = (Format-ConfluenceHtmlTable -Rows $propertyRows)
    $propMacro = Format-ConfluenceMacro -Name $macro.Name -SchemaVersion $macro.SchemaVersion -Contents (Format-ConfluenceMacroRichTextBody -Content $propTable)

    # return
    (Format-ConfluenceHtml -Tag "h1" -Contents "Properties") + $propMacro
}

function Get-ConfluenceUserContent($TemplateContent,$UserSectionMap = $PC_ConfluenceTemplates.Layout.UserSection.DefaultMap) {
    #start an array to track the content we find
    $userContent = @()

    # get the sections
    $sections = Get-ConfluenceSections -StorageFormat $TemplateContent
    
    # make sure the map matches the content we have, count-wise
    if ($sections.Count -ne $UserSectionMap.Count) { Throw "There is a mis-match between number of sections in the supplied UserSectionMap and the content"}

    # loop through the map and grab the content we need
    for($i=0;$i -lt $UserSectionMap.Count;$i++) {
        switch ($UserSectionMap[$i].GetType().Name) {
            Boolean {
                $userContent += (&{if($UserSectionMap[$i]) {$sections[$i]} else {$null}})
            }
            "Object[]" {
                # get the cells
                $cells = Get-ConfluenceCells -StorageFormat $sections[$i]
                $cellMap = $UserSectionMap[$i]
                # make sure the map matches the content we have, count-wise
                if ($cells.Count -ne $cellMap.Count) { Throw "There is a mis-match between the number of cells in a section in supplied UserSectionMap and the content"}
                # loop through the map and grab the content we need
                $cellContent = @()
                for($j=0;$j -lt $cellMap.Count;$j++) {
                    $cellContent += (&{if($cellMap[$j]) {$cells[$j]} else {$null}})                    
                }
                # add the cells to the user contents array
                $userContent += ,$cellContent
            }
            Default {
                Throw "Unrecognized value in UserSectionMap"
            }
        }
    }

    # return
    $userContent
}

function Get-ConfluenceSections($StorageFormat) {
    Split-ConfluenceLayout -StorageFormat $StorageFormat -StartToken $PC_ConfluenceTemplates.Layout.SectionStart -EndToken $PC_ConfluenceTemplates.Layout.SectionEnd
}

function Get-ConfluenceCells($StorageFormat) {
    Split-ConfluenceLayout -StorageFormat $StorageFormat -StartToken $PC_ConfluenceTemplates.Layout.CellStart -EndToken $PC_ConfluenceTemplates.Layout.CellEnd
}

function Split-ConfluenceLayout($StorageFormat,$StartToken,$EndToken)
{
    #start a list
    $sections = @()
    
    # find the starting indexes of the $StartToken in the entire body and loop through them
    $startMatches = [regex]::Matches($StorageFormat, $StartToken)
    foreach ($match in $startMatches) {
        # start by taking the part of the string that occurs after the start of the StartToken
        $section = $StorageFormat.Substring($match.Index)

        # now chop off everything after the end of the first EndToken in the remaining string
        $section = $section.Substring(0, ([regex]::Matches($section, $EndToken))[0].Index + $EndToken.Length)

        # add the trimmed section to the list
        $sections += $section
    }

    #return the list
    $sections
}

    # map structure pseudocode:
    # $map = $(sections)   # sections are either a bool ($true = UserSection) or an array of bools
    # 
    # Example:
    # $map = $($true,$($true,$false),$($false,$true,$false))
    # ----------------------------------------------------
    # |       SINGLE COLUMN USER SECTION                 |
    # ----------------------------------------------------
    # ----------------------------------------------------
    # |     USER CELL       |     GENERATED CELL         |
    # ----------------------------------------------------
    # ----------------------------------------------------
    # |  GEN. CELL    |   USER CELL    |    GEN. CELL    |      
    # ---------------------------------------------------- 

Export-ModuleMember -Function * -Variable *