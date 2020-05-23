using module .\ConfluenceHtmlTag.psm1

class ConfluenceHtmlTableCell : ConfluenceHtmlTag {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    

    #####################
    # PUBLIC PROPERTIES #
    #####################

    
    #####################
    # CONSTRUCTORS      #
    #####################

    ConfluenceHtmlTableCell(
        [string] $Contents
    ) : base("td", $Contents) {
        $this.Init($false,$false)
    }

    ConfluenceHtmlTableCell(
        [string] $Contents,
        [bool] $Header
    ) : base("td", $Contents) {
        $this.Init($Header,$false)
    }

    ConfluenceHtmlTableCell(
        [string] $Contents,
        [bool] $Header,
        [bool] $Center
    ) : base("td", $Contents) {
        $this.Init($Header,$Center)
    }

    #####################
    # HIDDEN METHODS    #
    #####################

    hidden
    [void]
    Init(
        [bool] $Header,
        [bool] $Center
    ) {
        $this.ForceSplit = $true
        $this.SetHeader($Header)
        $this.SetCenter($Center)
    }

    #####################
    # PUBLIC METHODS    #
    #####################

    [void]
    SetHeader(
        [bool] $Header
    ) {
        $this.Tag = if ($Header) { "th" } else { "td" }
    }

    [void]
    SetCenter(
        [bool] $Center
    ) {
        if ($Center) { $this.SetAttribute("style","text-align: center;") } else { $this.ClearAttribute("style")}
    }
}