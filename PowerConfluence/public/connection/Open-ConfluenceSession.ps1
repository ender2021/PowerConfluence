function Open-ConfluenceSession {
    [CmdletBinding(DefaultParameterSetName="PlainText")]
    param (
        # The Confluence username of the user performing actions
        [Parameter(Mandatory,Position=0,ParameterSetName="PlainText")]
        [string]
        $UserName,

        # The Confluence password (or API Token) of the user performing actions
        [Parameter(Mandatory,Position=1,ParameterSetName="PlainText")]
        [string]
        $Password,

        # The hostname of the Confluence instance to interact with (e.g. https://yoursite.atlassian.net/)
        [Parameter(Mandatory,Position=2)]
        [string]
        $HostName
    )
    process {
        $Global:PowerConfluence.Session = New-ConfluenceConnection -UserName $UserName -Password $Password -HostName $HostName
    }
}