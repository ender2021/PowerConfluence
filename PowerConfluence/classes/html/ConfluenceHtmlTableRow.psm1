using module .\ConfluenceHtmlTag.psm1
using module .\ConfluenceHtmlTableCell.psm1

class ConfluenceHtmlTableRow : ConfluenceHtmlTag {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    

    #####################
    # PUBLIC PROPERTIES #
    #####################

    [ConfluenceHtmlTableCell[]]
    $Cells

    [bool]
    $Header

    [bool]
    $Center
    
    #####################
    # CONSTRUCTORS      #
    #####################

    ConfluenceHtmlTableRow(
        
    ) : base("tr", $null) {
        $this.Init($null,$false,$false)
    }

    ConfluenceHtmlTableRow(
        [ConfluenceHtmlTableCell[]] $Cells
    ) : base("tr", $null) {
        $this.Init($Cells,$false,$false)
    }

    ConfluenceHtmlTableRow(
        [ConfluenceHtmlTableCell[]] $Cells,
        [bool] $Header
    ) : base("tr", $null) {
        $this.Init($Cells,$Header,$false)
    }

    ConfluenceHtmlTableRow(
        [ConfluenceHtmlTableCell[]] $Cells,
        [bool] $Header,
        [bool] $Center
    ) : base("tr", $null) {
        $this.Init($Cells,$Header,$Center)
    }

    #####################
    # HIDDEN METHODS    #
    #####################

    hidden
    [void]
    Init(
        [ConfluenceHtmlTableCell[]] $Cells,
        [bool] $Header,
        [bool] $Center
    ) {
        $this.ForceSplit = $true
        $this.SetCells($Cells,$false)
        $this.SetHeader($Header, $false)
        $this.SetCenter($Center, $false)
        $this.RefreshContents()
    }

    hidden
    [void]
    SetHeader(
        [bool] $Header,
        [bool] $Refresh
    ) {
        $this.Cells | ForEach-Object { $_.SetHeader($Header) }
        $this.Header = $Header
        if ($Refresh) { $this.RefreshContents() }
    }

    hidden
    [void]
    SetCenter(
        [bool] $Center,
        [bool] $Refresh
    ) {
        $this.Cells | ForEach-Object { $_.SetCenter($Center) }
        $this.Center = $Center
        if ($Refresh) { $this.RefreshContents()}
    }

    hidden
    [void]
    SetCells(
        [ConfluenceHtmlTableCell[]] $Cells,
        [bool] $Refresh
    ) {
        $this.Cells = $Cells
        if ($Refresh) { $this.RefreshContents() }
    }

    hidden
    [void]
    AddCell(
        [ConfluenceHtmlTableCell] $Cell,
        [bool] $Refresh
    ) {
        $this.Cells += $Cell
        if ($Refresh) { $this.RefreshContents() }
    }

    #####################
    # PUBLIC METHODS    #
    #####################

    [void]
    SetHeader(
        [bool] $Header
    ) {
        $this.SetHeader($Header,$true)
    }

    [void]
    SetCenter(
        [bool] $Center
    ) {
        $this.SetCenter($Center,$true)
    }

    [void]
    SetCells(
        [ConfluenceHtmlTableCell[]] $Cells
    ) {
        $this.SetCells($Cells,$true)
    }

    [void]
    AddCell(
        [ConfluenceHtmlTableCell] $Cell
    ) {
        $this.AddCell($Cell,$true)
    }

    [void]
    RefreshContents(){
        $this.Contents = $this.Cells | ForEach-Object { $_.ToString() }
    }
}