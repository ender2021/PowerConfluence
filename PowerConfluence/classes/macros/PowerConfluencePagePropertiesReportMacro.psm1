using module .\PowerConfluenceMacro.psm1

class PowerConfluencePagePropertiesReportMacro : PowerConfluenceMacro {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    hidden
    static
    [string]
    $DerivedMacroName = "detailssummary"

    hidden
    static
    [int]
    $DerivedMacroVersion = 2

    hidden
    static
    [int]
    $DefaultPageSize = 30

    #####################
    # PUBLIC PROPERTIES #
    #####################

    
    ################
    # CONSTRUCTORS #
    ################

    #default constructure
    PowerConfluencePagePropertiesReportMacro(
        [string] $Cql
    ) : base([PowerConfluencePagePropertiesReportMacro]::DerivedMacroName, [PowerConfluencePagePropertiesReportMacro]::DerivedMacroVersion) {
        $this.Init($Cql, [PowerConfluencePagePropertiesReportMacro]::DefaultPageSize, $null, $null, $null)
    }

    PowerConfluencePagePropertiesReportMacro(
        [string] $Cql,
        [int] $PageSize
    ) : base([PowerConfluencePagePropertiesReportMacro]::DerivedMacroName, [PowerConfluencePagePropertiesReportMacro]::DerivedMacroVersion) {
        $this.Init($Cql, $pageSize, $null, $null, $null)
    }

    PowerConfluencePagePropertiesReportMacro(
        [string] $Cql,
        [int] $PageSize,
        [string] $FirstColumn,
        [string] $Headings,
        [string] $SortBy
    ) : base([PowerConfluencePagePropertiesReportMacro]::DerivedMacroName, [PowerConfluencePagePropertiesReportMacro]::DerivedMacroVersion) {
        $this.Init($Cql, $pageSize, $FirstColumn, $Headings, $SortBy)
    }

    ##################
    # HIDDEN METHODS #
    ##################

    hidden
    [void]
    Init (
        [string] $Cql,
        [int] $PageSize,
        [string] $FirstColumn,
        [string] $Headings,
        [string] $SortBy
    ) {
        $this.SetParameter('cql', $Cql)
        $this.SetParameter('pageSize', $PageSize)
        if ($null -ne $FirstColumn) { $this.SetParameter('firstcolumn', $FirstColumn) }
        if ($null -ne $Headings) { $this.SetParameter('headings', $FirstColumn) }
        if ($null -ne $SortBy) { $this.SetParameter('sortBy', $FirstColumn) }
    }

    ##################
    # PUBLIC METHODS #
    ##################

    
}