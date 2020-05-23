class ConfluenceHtmlTag {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    

    #####################
    # PUBLIC PROPERTIES #
    #####################

    [string]
    $Tag

    [string]
    $Contents

    [hashtable]
    $Attributes

    [bool]
    $ForceSplit

    #####################
    # CONSTRUCTORS      #
    #####################

    ConfluenceHtmlTag(
        [string] $Tag
    ) {
        $this.Init($Tag, $null, $null)
    }

    ConfluenceHtmlTag(
        [string] $Tag,
        [hashtable] $Attributes
    ) {
        $this.Init($Tag, $null, $Attributes)
    }

    ConfluenceHtmlTag(
        [string] $Tag,
        [string] $Contents
    ) {
        $this.Init($Tag, $Contents, $null)
    }

    ConfluenceHtmlTag(
        [string] $Tag,
        [string] $Contents,
        [hashtable] $Attributes
    ) {
        $this.Init($Tag, $Contents, $Attributes)
    }

    #####################
    # HIDDEN METHODS    #
    #####################

    hidden
    [void]
    Init(
        [string] $Tag,
        [string] $Contents,
        [hashtable] $Attributes
    ) {
        $this.Tag = $Tag
        $this.Contents = $Contents
    }

    #####################
    # PUBLIC METHODS    #
    #####################

    [void]
    SetAttribute(
        [string] $Key,
        [string] $Value
    ) {
        $this.ClearAttribute($Key)
        $this.Attributes.Add($Key,$Value)
    }

    [void]
    ClearAttribute(
        [string] $Key
    ) {
        if ($this.Attributes.ContainsKey($Key)) {
            $this.Attributes.Remove($key)
        }
    }

    [string]
    ToString() {
        $attrStr = ""
        if ($this.Attributes.Count -gt 0) {
            foreach($key in $this.Attributes.Keys) {
                $attrStr += " {0}=""{1}""" -f $key, $this.Attributes[$key]
            }
        }
        if(!$this.ForceSplit -and ($null -eq $this.Contents -or $this.Contents -eq "")) {
            $toReturn = "<{0}{1} />" -f $this.Tag, $attrStr
        } else {
            $toReturn = "<{0}{2}>{1}</{0}>" -f $this.Tag, $this.Contents, $attrStr
        }
        return $toReturn
    }
}