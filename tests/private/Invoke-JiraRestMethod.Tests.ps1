. $PSScriptRoot\..\mocks\Mock-InvokeRestMethod.ps1
. $PSScriptRoot\..\mocks\Mock-NewConfluenceConnection.ps1

$InvokeConfluenceRestRequest_ContentType = "application/json"

Describe "Invoke-ConfluenceRestMethod" {
    Context "Missing/Malformed ConfluenceConnection Object" {
        It "throws 'Missing/Malformed ConfluenceConnection' when connection is not supplied and no session is open" {
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $Global:PowerConfluence.Session = $null
            { Invoke-ConfluenceRestMethod $null "some/path" "GET" } | Should -Throw 'Missing/Malformed ConfluenceConnection'
        }
        It 'throws validation error when the ConfluenceConnection object is missing required keys' {
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            { Invoke-ConfluenceRestMethod @{AuthHeader=@{}} "some/path" "GET" } | Should -Throw 'Missing/Malformed ConfluenceConnection'
        }
    }
    Context "AuthHeader" {
        It "created the Authorization key in the Headers parameter" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "GET"
            $req.Headers.Keys | Should -Contain "Authorization"
        }
        It "set the value of the Authorization key in the Headers parameter" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "GET"
            $req.Headers.Authorization | Should -Be $conn.AuthHeader.Authorization
        }
    }
    Context "ContentType" {
        It "sets ContentType for bodyless requests" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "GET"
            $req.ContentType | Should -Be $InvokeConfluenceRestRequest_ContentType
        }
        It "sets ContentType for query requests" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "GET" -Query @{some="content"}
            $req.ContentType | Should -Be $InvokeConfluenceRestRequest_ContentType
        }
        It "sets ContentType for Json Body requests" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "POST" -Body @{some="content"}
            $req.ContentType | Should -Be $InvokeConfluenceRestRequest_ContentType
        }
        It "sets ContentType for Simple Body requests" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "POST" -LiteralBody '{"some"="content"}'
            $req.ContentType | Should -Be $InvokeConfluenceRestRequest_ContentType
        }
        It "does not set ContentType for Form requests" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $req = Invoke-ConfluenceRestMethod $conn $path "POST" -Form @{some="content"}
            $req.ContentType | Should -BeNullOrEmpty
        }
    }
    Context "HttpMethod" {
        It "sets HttpMethod correctly" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb
            $req.Method | Should -Be $verb
        }
        It "does not allow unapproved HTTP verbs" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "BURP"
            {Invoke-ConfluenceRestMethod $conn $path $verb} | Should -Throw "validate"
        }
    }
    Context "GET/DELETE body validation" {
        It "does not allow -Body when using 'GET'" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            {Invoke-ConfluenceRestMethod $conn $path $verb -Body @{some="content"}} | Should -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "does not allow -Body when using 'DELETE'" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "DELETE"
            {Invoke-ConfluenceRestMethod $conn $path $verb -Body @{some="content"}} | Should -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "does not allow -LiteralBody when using 'GET'" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            {Invoke-ConfluenceRestMethod $conn $path $verb -LiteralBody '{"some"="content"}'} | Should -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "does not allow -LiteralBody when using 'DELETE'" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "DELETE"
            {Invoke-ConfluenceRestMethod $conn $path $verb -LiteralBody '{"some"="content"}'} | Should -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "does not allow -Form when using 'GET'" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            {Invoke-ConfluenceRestMethod $conn $path $verb -Form @{some="content"}} | Should -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "does not allow -BodyKvp when using 'DELETE'" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "DELETE"
            {Invoke-ConfluenceRestMethod $conn $path $verb -Form @{some="content"}} | Should -Throw "Invalid HttpMethod / Parameter combination"
        }
    }
    Context "POST/PUT/PATCH body validation" {
        It "allows 'POST' without a body or form parameter" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            {Invoke-ConfluenceRestMethod $conn $path $verb} | Should -Not -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "allows 'PUT' without a body or form parameter" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PUT"
            {Invoke-ConfluenceRestMethod $conn $path $verb} | Should -Not -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "allows 'PATCH' without a body or form parameter" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PATCH"
            {Invoke-ConfluenceRestMethod $conn $path $verb} | Should -Not -Throw "Invalid HttpMethod / Parameter combination"
        }
        It "allows 'POST' with -Body" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Body @{some="Content"}
            $req.Method | Should -Be $verb
        }
        It "allows 'PUT' with -Body" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PUT"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Body @{some="Content"}
            $req.Method | Should -Be $verb
        }
        It "allows 'PATCH' with -Body" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PATCH"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Body @{some="Content"}
            $req.Method | Should -Be $verb
        }
        It "allows 'POST' with -LiteralBody" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -LiteralBody '{"some"="content"}'
            $req.Method | Should -Be $verb
        }
        It "allows 'PUT' with -LiteralBody" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PUT"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -LiteralBody '{"some"="content"}'
            $req.Method | Should -Be $verb
        }
        It "allows 'PATCH' with -LiteralBody" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PATCH"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -LiteralBody '{"some"="content"}'
            $req.Method | Should -Be $verb
        }
        It "allows 'POST' with -Form" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Form @{some="Content"}
            $req.Method | Should -Be $verb
        }
        It "allows 'PUT' with -Form" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PUT"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Form @{some="Content"}
            $req.Method | Should -Be $verb
        }
        It "allows 'PATCH' with -Form" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "PATCH"
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Form @{some="Content"}
            $req.Method | Should -Be $verb
        }
    }
    Context "Query/QueryKvp" {
        It "GET with one query param as hash" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            $query = @{one="param"}
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Query $query
            $req.Uri | Should -Be ($conn.HostName + $path + '?' + "one=param")
        }
        It "GET with multiple query params as hash" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            $query = @{one="param";two="items"}
            $expectedPath = $conn.HostName + $path
            $expectedQueries = @($expectedPath + '?' + "one=param&two=items";$expectedPath + '?' + "two=items&one=param")
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Query $query
            $req.Uri | Should -BeIn $expectedQueries
        }
        It "GET with one query param as kvp array" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            $query = @(@{key="one";value="param"})
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -QueryKvp $query
            $req.Uri | Should -Be ($conn.HostName + $path + '?' + "one=param")
        }
        It "GET with multiple query params as kvp array" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "GET"
            $query = @(@{key="one";value="param"};@{key="two";value="items"})
            $expectedPath = $conn.HostName + $path
            $expectedQueries = @($expectedPath + '?' + "one=param&two=items";$expectedPath + '?' + "two=items&one=param")
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -QueryKvp $query
            $req.Uri | Should -BeIn $expectedQueries
        }
    }
    Context "Body/LiteralBody/Form" {
        It "correctly serializes a simple body" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $body = @{one="item";two="things"}
            $expected = @(
                '{"one":"item","two":"things"}'
                '{"two":"things","one":"item"}'
            )
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Body $body
            $req.Body | Should -BeIn $expected
        }
        It "correctly serializes a complex body" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $body = @{zero3=@{one=@{two=@{three="item"}}};zero5=@{one=@{two=@{three=@{four=@{five="item"}}}}}}
            $expected = @(
                '{"zero3":{"one":{"two":{"three":"item"}}},"zero5":{"one":{"two":{"three":{"four":{"five":"item"}}}}}}'
                '{"zero5":{"one":{"two":{"three":{"four":{"five":"item"}}}}},"zero3":{"one":{"two":{"three":"item"}}}}'
            )
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Body $body
            $req.Body | Should -BeIn $expected
        }
        It "correctly sets a literal body" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $literalBody = '{"zero3":{"one":{"two":{"three":"item"}}},"zero5":{"one":{"two":{"three":{"four":{"five":"item"}}}}}}'
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -LiteralBody $literalBody
            $req.Body | Should -Be $literalBody
        }
        It "correctly sets a Form" {
            Mock "New-ConfluenceConnection" $MockNewConfluenceConnection
            Mock "Invoke-RestMethod" $MockInvokeRestMethod
            $conn = New-ConfluenceConnection dummy dummy dummy
            $path = "some/path"
            $verb = "POST"
            $form = @{zero3=@{one=@{two=@{three="item"}}};zero5=@{one=@{two=@{three=@{four=@{five="item"}}}}}}
            $req = Invoke-ConfluenceRestMethod $conn $path $verb -Form $form
            $req.Form | Should -Be $form
        }
    }
}