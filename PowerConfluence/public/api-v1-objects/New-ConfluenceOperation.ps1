function New-ConfluenceOperation {
    [CmdletBinding()]
    param (
        # The operation
        [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName)]
        [ValidateSet("administer", "copy", "create", "delete", "export", "move", "purge",
                     "purge_version", "read", "restore", "update", "use")]
        [string]
        $Operation,

        # The target type
        [Parameter(Mandatory,Position=1,ValueFromPipelineByPropertyName)]
        [ValidateSet("page", "blogpost", "comment", "attachment", "space")]
        [string]
        $TargetType,

        # The context in which the operation will be used (enables validation)
        [Parameter(Position=2,ValueFromPipelineByPropertyName)]
        [ValidateSet("SpacePermission")]
        [string]
        $Context="SpacePermission"
    )
    begin {
        $results = @()
    }
    process {
        switch ($Context) {
            "SpacePermission" { 
                if (@("create","read","delete","export","administer") -notcontains $Operation) {throw "Invalid Operation: Context $context does not have operation $Operation"}
                if ((@("create","delete") -contains $Operation) -and (@("page", "blogpost", "comment", "attachment") -notcontains $TargetType)) {throw "Invalid Operation: Context $context does not have TargetType $TargetType for operation $Operation"}
                if ((@("read","export","administer") -contains $Operation) -and ($TargetType -ne "space")) {throw "Invalid Operation: Context $context does not have TargetType $TargetType for operation $Operation"}
            }
            Default {}
        }

        $results += [pscustomobject]@{
            operation = $Operation
            targetType = $TargetType
        }
    }
    end {
        $results
    }
}