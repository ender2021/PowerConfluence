Describe "Open-ConfluenceSession" {
    Context "PlainText" {
        It "sets property 'Session' of the global object" {
            $Global:PowerConfluence.Session = $null
            Open-ConfluenceSession "justin" "password" "host.name"
            $Global:PowerConfluence.Session | Should -Not -BeNullOrEmpty
        }
        It "sets property 'Session.AuthHeader' on the global object" {
            $Global:PowerConfluence.Session = $null
            Open-ConfluenceSession "justin" "password" "host.name"
            $Global:PowerConfluence.Session.Keys | Should -Contain "AuthHeader"
        }
        It "sets property 'Session.AuthHeader.Authorization' on the global object" {
            $Global:PowerConfluence.Session = $null
            Open-ConfluenceSession "justin" "password" "host.name"
            $Global:PowerConfluence.Session.AuthHeader.Keys | Should -Contain "Authorization"
        }
        It "correctly sets property 'Session.AuthHeader.Authorization' of the global object" {
            $Global:PowerConfluence.Session = $null
            Open-ConfluenceSession "justin" "password" "host.name"
            $Global:PowerConfluence.Session.AuthHeader.Authorization | Should -Be "Basic anVzdGluOnBhc3N3b3Jk"
        }
        It "sets property 'Session.HostName' on the global object" {
            $Global:PowerConfluence.Session = $null
            Open-ConfluenceSession "justin" "password" "host.name"
            $Global:PowerConfluence.Session.Keys | Should -Contain "HostName"
        }
        It "correctly sets property 'Session.HostName' on the global object" {
            $Global:PowerConfluence.Session = $null
            Open-ConfluenceSession "justin" "password" "host.name"
            $Global:PowerConfluence.Session.HostName | Should -Be "host.name"
        }
    }
}