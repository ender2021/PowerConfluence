$Templates = @{
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