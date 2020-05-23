class PowerConfluenceFormattingGlobal {

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

    PowerConfluenceFormattingGlobal(
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