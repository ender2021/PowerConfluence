using module .\PowerConfluenceMacro.psm1

class PowerConfluencePagePropertiesMacro : PowerConfluenceMacro {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    hidden
    static
    [string]
    $DerivedMacroName = "details"

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

    #default constructor
    PowerConfluencePagePropertiesMacro(
        [string] $Body
    ) : base([PowerConfluencePagePropertiesMacro]::DerivedMacroName, [PowerConfluencePagePropertiesMacro]::DerivedMacroVersion, $Body) {

    }

    ##################
    # HIDDEN METHODS #
    ##################

    
    ##################
    # PUBLIC METHODS #
    ##################

    
}