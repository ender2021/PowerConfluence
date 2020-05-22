class PowerConfluenceGlobal {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    

    #####################
    # PUBLIC PROPERTIES #
    #####################

    [object[]]
    $Emoticons

    [object[]]
    $Templates

    #####################
    # CONSTRUCTORS      #
    #####################

    PowerConfluenceGlobal(
        [object[]] $Emoticons,
        [object[]] $Templates
    ) {
        $this.Init($Emoticons, $Templates)
    }

    #####################
    # HIDDEN METHODS    #
    #####################

    hidden
    [void]
    Init(
        [object[]] $Emoticons,
        [object[]] $Templates
    ) {
        $this.Emoticons = $Emoticons
        $this.Templates = $Templates
    }

    #####################
    # PUBLIC METHODS    #
    #####################

    
}