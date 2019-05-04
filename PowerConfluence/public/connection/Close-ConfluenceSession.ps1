function Close-ConfluenceSession() {
    process {
        $Global:PowerConfluence.Session = $null
    }
}