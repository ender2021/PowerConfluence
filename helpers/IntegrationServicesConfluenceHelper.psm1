###########################
# useful string libraries #
###########################


###############################################################
#  package execution formatting                               #
###############################################################

function Format-IntegrationServicesPackageExecutions ($Executions,[switch]$IncludePackage) {
    # build the table
    $rows = @()
    
    # create the header row
    $headers = @()
    $headers += "ID"
    if ($IncludePackage) {$headers += "Folder"}
    if ($IncludePackage) {$headers += "Project"}
    if ($IncludePackage) {$headers += "Package"}
    $headers += "Completed"
    $headers += "Status"
    $headers += "Start Time"
    $headers += "End Time"
    $headers += "Duration"
    $rows += Format-ConfluenceHtmlTableHeaderRow -Headers $headers

    # build out the executions rows
    foreach ($e in $Executions) {

        #TODO - decide on how to render status - maybe the status macro hurr durr
        $statusContent = ""

        #TODO - calculate duration
        $duration = 

        $cells = @()
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.Id
        if ($IncludePackage) {$cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.FolderName}
        if ($IncludePackage) {$cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.ProjectName}
        if ($IncludePackage) {$cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.PackageName}
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents (Format-ConfluenceIcon -Icon $e.Completed) -Center $true
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $statusContent
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.StartTime
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.EndTime
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $duration
        $rows += Format-ConfluenceHtmlTableRow -Cells $cells
        $rows += Format-ConfluenceHtmlTableRow -Cells $cells
    }
    
    # pull it all together
    $title = Format-ConfluenceHtml -Tag "h1" -Contents "Execution(s)"    
    $table = Format-ConfluenceHtmlTable -Rows $rows
    
    # return
    $title + $table
}

function Format-IntegrationServicesExecutionManifestConfluencePage($Executions,$UserSection=(Format-ConfluenceDefaultUserSection)) {
    Format-IntegrationServicesPackageExecutions -Executions $Executions -IncludePackage
}

###############################################################
#  Execution Manifest page publication                        #
###############################################################

function Add-IntegrationServicesExecutionManifestConfluencePage($ConfluenceConnection,$SpaceKey,$AncestorID=-1,$Title="",$Executions) {
    $pageContents = Format-IntegrationServicesExecutionManifestConfluencePage -Executions $Executions
    Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $Title -Contents $pageContents -AncestorID $AncestorID
}

function Update-IntegrationServicesExecutionManifestConfluencePage($ConfluenceConnection,$Page,$Title="",$Executions) {
    
    # use an updated title, or keep the old title if a new one is not supplied
    $updateTitle = (&{if($Title -eq "") {$Page.title} else {$Title}})

    # get the user-generated content
    $userContent = Get-ConfluenceUserContent -TemplateContent $Page.body.storage.value

    # render the content
    $pageContents = Format-IntegrationServicesExecutionManifestConfluencePage -Executions $Executions -UserSection $userContent

    # post the update
    Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -CurrentVersion $Page.version.number -Title $updateTitle -Contents $pageContents
}

function Publish-IntegrationServicesExecutionManifestConfluencePage($ConfluenceConnection,$SpaceKey,$Title,$Executions,$AncestorID=-1) {
    #look for an existing page
    $page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $Title -Expand @("body.storage","version")
    if ($page) {
        # update the page if it exists
        Update-IntegrationServicesExecutionManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -Page $page -Executions $Executions
    } else {
        #create one if it doesn't
        Add-IntegrationServicesExecutionManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $Title -Executions $Executions -AncestorID $AncestorID
    }
}

###############################################################
#  SSIS data retrieval                                        #
###############################################################

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