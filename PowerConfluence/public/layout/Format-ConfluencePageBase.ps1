function Format-ConfluencePageBase($ContentMap) {
    $content = @()

    foreach ($i in $ContentMap) {
        switch ($i.GetType().Name) {
            Hashtable {
                $content += (&{if($i.Generated){Format-ConfluenceAutomatedSection -GeneratedContent $i.Content}else{$i.Content}})
            }
            "Object[]" {
                $sectionContents = @()
                foreach ($j in $i) {
                    if ($j.GetType().Name -ne "Hashtable") { Throw "ContentMap is malformed at $i`[$j`]"}
                    $sectionContents += (&{if($j.Generated){Format-ConfluenceAutomatedCell -GeneratedContent $j.Content}else{$j.Content}})
                }
                #TODO - figure out how to parse  mutli-cell sections better
                $sectionType = switch ($i.Count) {
                    1 {"single"}
                    2 {"two_equal"}
                    3 {"three_equal"}
                    Default {Throw "ContentMap is malformed at $i"}
                }
                # add the cells to the user contents array
                $content += Format-ConfluenceSection $sectionContents -Type $sectionType
            }
            Default {
                Throw "Unrecognized value in ContentMap: $i"
            }
        }
    }
    Format-ConfluenceLayout -Contents "$content"
}