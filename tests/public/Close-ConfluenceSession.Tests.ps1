Describe "Close-ConfluenceSession" {
    It "does not remove property 'Session' of the global object" {
        $Global:PowerConfluence.Session = @{AuthHeader=@{Authorization="Basic anVzdGluOnBhc3N3b3Jk"};HostName="host.name"}        
        Close-ConfluenceSession
        $Global:PowerConfluence.Keys | Should -Contain "Session"
    }
    It "sets property 'Session' of the global object to null" {
        $Global:PowerConfluence.Session = @{AuthHeader=@{Authorization="Basic anVzdGluOnBhc3N3b3Jk"};HostName="host.name"}        
        Close-ConfluenceSession
        $Global:PowerConfluence.Session | Should -BeNullOrEmpty
    }
}