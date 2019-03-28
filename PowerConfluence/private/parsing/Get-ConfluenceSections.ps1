function Get-ConfluenceSections($StorageFormat) {
    Split-ConfluenceLayout -StorageFormat $StorageFormat -StartToken $global:PowerConfluence.Templates.Layout.SectionStart -EndToken $global:PowerConfluence.Templates.Layout.SectionEnd
}