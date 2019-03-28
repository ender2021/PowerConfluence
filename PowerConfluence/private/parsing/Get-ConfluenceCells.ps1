function Get-ConfluenceCells($StorageFormat) {
    Split-ConfluenceLayout -StorageFormat $StorageFormat -StartToken $global:PowerConfluence.Templates.Layout.CellStart -EndToken $global:PowerConfluence.Templates.Layout.CellEnd
}