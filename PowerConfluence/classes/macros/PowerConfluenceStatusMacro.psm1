using module .\PowerConfluenceMacro.psm1

class PowerConfluenceStatusMacro : PowerConfluenceMacro {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    hidden
    static
    [string]
    $DerivedMacroName = "status"

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

    #default constructure w/o specifying subtle
    PowerConfluenceStatusMacro(
        [string] $Color,
        [string] $Text
    ) : base([PowerConfluenceStatusMacro]::DerivedMacroName,[PowerConfluenceStatusMacro]::DerivedMacroVersion) {
        $this.Init($Color, $Text, $false)
    }

    #specifying subtle
    PowerConfluenceStatusMacro(
        [string] $Color,
        [string] $Text,
        [bool] $Subtle
    ) : base([PowerConfluenceStatusMacro]::DerivedMacroName,[PowerConfluenceStatusMacro]::DerivedMacroVersion) {
        $this.Init($Color, $Text, $Subtle)
    }

    ##################
    # HIDDEN METHODS #
    ##################

    hidden
    [void]
    Init (
        [string] $Color,
        [string] $Text,
        [bool] $Subtle
    ) {
        $this.SetParameter('colour', $Color)
        $this.SetParameter('title', $text)
        $this.SetParameter('subtle', $Subtle)
    }

    ##################
    # PUBLIC METHODS #
    ##################

    
}