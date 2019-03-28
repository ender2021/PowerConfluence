function Get-ConfluenceContentMap($TemplateContent,$UserContentMap = $global:PowerConfluence.Templates.Layout.UserSection.DefaultMap) {
    #start an array to track the content we find
    $userContent = @()

    # get the sections
    $sections = Get-ConfluenceSections -StorageFormat $TemplateContent

    # if the page doesn't have sections, wrap the content in a section and go again
    if ($sections -eq $null) { $sections = Get-ConfluenceSections -StorageFormat (Format-ConfluenceSection -Contents $TemplateContent) }

    # make sure the map matches the content we have, count-wise
    if ($sections.Count -ne $UserContentMap.Count) { Throw "There is a mis-match between number of sections in the supplied UserContentMap and the content"}

    # loop through the map and grab the content we need
    for($i=0;$i -lt $UserContentMap.Count;$i++) {
        switch ($UserContentMap[$i].GetType().Name) {
            Boolean {
                $userContent += (&{if($UserContentMap[$i]) {@{Content=$sections[$i];Generated=$false}} else {@{Content=$null;Generated=$true}}})
            }
            "Object[]" {
                # get the cells
                $cells = Get-ConfluenceCells -StorageFormat $sections[$i]
                $cellMap = $UserContentMap[$i]
                # make sure the map matches the content we have, count-wise
                if ($cells.Count -ne $cellMap.Count) { Throw "There is a mis-match between the number of cells in a section in supplied UserContentMap and the content"}
                # loop through the map and grab the content we need
                $cellContent = @()
                for($j=0;$j -lt $cellMap.Count;$j++) {
                    $cellContent += (&{if($cellMap[$j]) {@{Content=$cells[$j];Generated=$false}} else {@{Content=$null;Generated=$true}}})                    
                }
                # add the cells to the user contents array
                $userContent += ,$cellContent
            }
            Default {
                Throw "Unrecognized value in UserContentMap"
            }
        }
    }

    # return
    $userContent
}