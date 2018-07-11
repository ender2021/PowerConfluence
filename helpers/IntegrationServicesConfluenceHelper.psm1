###########################
# useful string libraries #
###########################

<#
$_integrationServicesPackageTemplateStrings = @{
    ExecutionsTableEnd = '</tbody></table>';
}
#>

function Format-IntegrationServicesPackageExecutions ($Executions,[switch]$IncludePackage) {

    '<tr><th>ID</th><th>Completed</th><th>Status</th><th>Start Time</th><th>End Time</th><th>Duration</th></tr>';
    # build the table
    $rows = @()
    
    # create the header row
    $headers = @()
    $headers += "ID"
    if ($IncludePackage) {$headers += "Package"}
    $headers += "Completed"
    $headers += "Status"
    $headers += "Start Time"
    $headers += "End Time"
    $headers += "Duration"
    $rows += Format-ConfluenceHtmlTableHeaderRow -Headers $headers

    # build out the schedule rows
    foreach ($e in $Executions) {
        $cells = @(
                @{Type="td";Contents=(Format-ConfluencePageLink -TargetPageTitle $schedule.Parent -LinkText $schedule.Parent)},
                @{Type="td";Contents=(Format-ConfluenceIcon -IconName (&{If($schedule.JobEnabled) {$PC_ConfluenceEmoticons.Tick} Else {$PC_ConfluenceEmoticons.Cross}}));Center=$true},
                @{Type="td";Contents=$schedule.Name},
                @{Type="td";Contents=(Format-ConfluenceIcon -IconName (&{If($schedule.IsEnabled) {$PC_ConfluenceEmoticons.Tick} Else {$PC_ConfluenceEmoticons.Cross}}));Center=$true},
                @{Type="td";Contents=$schedule.FrequencyTranslation},
                @{Type="td";Contents=$schedule.StartTimeTranslation}
            )
        $rows += Format-ConfluenceHtmlTableRow -Cells $cells
    }
    
    # pull it all together
    $title = Format-ConfluenceHtml -Tag "h1" -Contents "Execution(s)"    
    $table = Format-ConfluenceHtmlTable -Rows $rows
    
    # return
    Format-ConfluencePageBase -GeneratedContent ($title + $table) -UserSection $UserSection    
}

function Get-IntegrationServicesCatalog($ServerName) {
    #magic string
    $ISNamespace = "Microsoft.SqlServer.Management.IntegrationServices"

    # Load the IntegrationServices Assembly
    [System.Reflection.Assembly]::LoadWithPartialName($ISNamespace) | Out-Null;

    # Create a connection to the server
    $sqlConnectionString = "Data Source=$ServerName;Initial Catalog=master;Integrated Security=SSPI;"
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $sqlConnectionString

    # Create the Integration Services object
    $integrationServices = New-Object $ISNamespace".IntegrationServices" $sqlConnection

    # Return the Integration Services catalog
    $integrationServices.Catalogs["SSISDB"]
}

function Get-IntegrationServicesPackageList($ServerName,$FolderName,$ProjectName) {

    # get the catalog
    $catalog = Get-IntegrationServicesCatalog($ServerName)

    # Get the folder
    $folder = $catalog.Folders[$FolderName]

    # Get the project
    $project = $folder.Projects[$ProjectName]

    # return the packages
    $project.Packages
}