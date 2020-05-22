class PowerConfluenceMacro {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    hidden
    static
    [string]
    $MacroTemplateString = '<ac:structured-macro ac:name="{0}" ac:schema-version="{1}">{2}</ac:structured-macro>'

    hidden
    static
    [string]
    $ParameterTemplateString = '<ac:parameter ac:name="{0}">{1}</ac:parameter>'

    hidden
    static
    [string]
    $RichTextBodyTemplateString = '<ac:rich-text-body>{0}</ac:rich-text-body>'

    #####################
    # PUBLIC PROPERTIES #
    #####################

    [string]
    $Name

    [int]
    $SchemaVersion

    [hashtable]
    $Parameters

    [string]
    $RichTextBody

    #####################
    # CONSTRUCTORS      #
    #####################

    PowerConfluenceMacro(
        [string] $Name,
        [int] $SchemaVersion
    ) {
        $this.Init($Name, $SchemaVersion, $null, @{})
    }

    PowerConfluenceMacro(
        [string] $Name,
        [int] $SchemaVersion,
        [string] $RichTextBody
    ) {
        $this.Init($Name, $SchemaVersion, $RichTextBody, @{})
    }

    PowerConfluenceMacro(
        [string] $Name,
        [int] $SchemaVersion,
        [hashtable] $Parameters
    ) {
        $this.Init($Name, $SchemaVersion, $null, $Parameters)
    }

    PowerConfluenceMacro(
        [string] $Name,
        [int] $SchemaVersion,
        [string] $RichTextBody,
        [hashtable] $Parameters
    ) {
        $this.Init($Name, $SchemaVersion, $RichTextBody, $Parameters)
    }

    #####################
    # HIDDEN METHODS    #
    #####################

    hidden
    [void]
    Init(
        [string] $Name,
        [int] $SchemaVersion,
        [string] $RichTextBody,
        [hashtable] $Parameters
    ) {
        $this.Name = $Name
        $this.SchemaVersion = $SchemaVersion
        $this.RichTextBody = $RichTextBody
        $this.Parameters = $Parameters
    }

    #####################
    # PUBLIC METHODS    #
    #####################

    [void]
    SetParameter(
        [string] $Key,
        [object] $Value
    ) {
        if ($this.Parameters.ContainsKey($Key)) {
            $this.Parameters.Remove($key)
        }
        $this.Parameters.Add($Key,$Value)
    }

    [string]
    Render()
    {
        $contents = @()

        if ($this.Parameters.Count -gt 0) {
            foreach($key in $this.Parameters.Keys) {
                $contents += [PowerConfluenceMacro]::ParameterTemplateString -f $key,$this.Parameters.Item($key)
            }
        }
        if ($null -ne $this.RichTextBody -and $this.RichTextBody -ne "") {
            $contents += [PowerConfluenceMacro]::RichTextBodyTemplateString -f $this.RichTextBody
        }

        return [PowerConfluenceMacro]::MacroTemplateString -f $this.Name,$this.SchemaVersion,"$contents"
    }
}