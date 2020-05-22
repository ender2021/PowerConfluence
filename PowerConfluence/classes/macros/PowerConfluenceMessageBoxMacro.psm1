using module .\PowerConfluenceMacro.psm1

class PowerConfluenceMessageBoxMacro : PowerConfluenceMacro {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    hidden
    static
    [int]
    $DerivedMacroVersion = 1

    #####################
    # PUBLIC PROPERTIES #
    #####################

    
    ################
    # CONSTRUCTORS #
    ################

    PowerConfluenceMessageBoxMacro(
        [string] $Type,
        [string] $Body
    ) : base($Type,[PowerConfluenceMessageBoxMacro]::DerivedMacroVersion,$Body) {
        $this.Init("",$true)
    }

    PowerConfluenceMessageBoxMacro(
        [string] $Type,
        [string] $Body,
        [string] $Title
    ) : base($Type,[PowerConfluenceMessageBoxMacro]::DerivedMacroVersion,$Body) {
        $this.Init($Title, $true)
    }

    PowerConfluenceMessageBoxMacro(
        [string] $Type,
        [string] $Body,
        [bool] $ShowIcon
    ) : base($Type,[PowerConfluenceMessageBoxMacro]::DerivedMacroVersion,$Body) {
        $this.Init("", $ShowIcon)
    }

    PowerConfluenceMessageBoxMacro(
        [string] $Type,
        [string] $Body,
        [string] $Title,
        [bool] $ShowIcon
    ) : base($Type,[PowerConfluenceMessageBoxMacro]::DerivedMacroVersion,$Body) {
        $this.Init($Title, $ShowIcon)
    }

    ##################
    # HIDDEN METHODS #
    ##################

    hidden
    [void]
    Init (
        [string] $Title,
        [bool] $ShowIcon
    ) {
        if ($null -ne $Title) { $Title="" }
        $this.SetParameter('title', $Title)
        $this.SetParameter('icon', $ShowIcon)
    }

    ##################
    # PUBLIC METHODS #
    ##################

    
}