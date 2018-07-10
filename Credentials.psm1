$Credentials = @{
    SqlAgentServerDev="app1.dev.sa.ucsb.edu,2433"
    UserName="mead-j@sa.ucsb.edu"
    ApiToken="UPHNV1FIsghhdkXl7y8R00C4"
    HostName="https://sfs-iam.atlassian.net"
    #HostName="https://ucsb-sist.atlassian.net"
}

Export-ModuleMember -Function * -Variable *