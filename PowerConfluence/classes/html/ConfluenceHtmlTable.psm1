using module .\ConfluenceHtmlTag.psm1
using module .\ConfluenceHtmlTableRow.psm1

class ConfluenceHtmlTable : ConfluenceHtmlTag {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    

    #####################
    # PUBLIC PROPERTIES #
    #####################

    [ConfluenceHtmlTableRow[]]
    $Rows

    [bool]
    $Center
    
    #####################
    # CONSTRUCTORS      #
    #####################

    ConfluenceHtmlTable(
        
    ) : base("table", $null) {
        $this.Init($null,$false)
    }

    ConfluenceHtmlTable(
        [ConfluenceHtmlTableRow[]] $Rows
    ) : base("table", $null) {
        $this.Init($Rows,$false)
    }

    ConfluenceHtmlTable(
        [ConfluenceHtmlTableRow[]] $Rows,
        [bool] $Center
    ) : base("table", $null) {
        $this.Init($Rows,$Center)
    }

    #####################
    # HIDDEN METHODS    #
    #####################

    hidden
    [void]
    Init(
        [ConfluenceHtmlTableRow[]] $Rows,
        [bool] $Center
    ) {
        $this.ForceSplit = $true
        $this.SetAttribute("class", "relative-table")
        $this.SetRows($Rows,$false)
        $this.SetCenter($Center, $false)
        $this.RefreshContents()
    }

    hidden
    [void]
    SetCenter(
        [bool] $Center,
        [bool] $Refresh
    ) {
        $this.Rows | ForEach-Object { $_.SetCenter($Center) }
        $this.Center = $Center
        if ($Refresh) { $this.RefreshContents()}
    }

    hidden
    [void]
    SetRows(
        [ConfluenceHtmlTableRow[]] $Rows,
        [bool] $Refresh
    ) {
        $this.Rows = $Rows
        if ($Refresh) { $this.RefreshContents() }
    }

    hidden
    [void]
    AddRow(
        [ConfluenceHtmlTableRow] $Row,
        [bool] $Refresh
    ) {
        $this.Rows += $Row
        if ($Refresh) { $this.RefreshContents() }
    }

    #####################
    # PUBLIC METHODS    #
    #####################

    [void]
    SetCenter(
        [bool] $Center
    ) {
        $this.SetCenter($Center,$true)
    }

    [void]
    SetRows(
        [ConfluenceHtmlTableRow[]] $Rows
    ) {
        $this.SetRows($Rows,$true)
    }

    [void]
    AddRow(
        [ConfluenceHtmlTableRow] $Row
    ) {
        $this.AddRow($Row,$true)
    }

    [void]
    RefreshContents(){
        $body = $this.Rows | ForEach-Object { $_.ToString() }
        $this.Contents = (New-Object ConfluenceHtmlTag @("tbody",$body)).ToString()
    }

}