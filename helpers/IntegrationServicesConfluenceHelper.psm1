###########################
# useful string libraries #
###########################

$_integrationServicesPackageManifestConfiguration = @{
    PagePropertiesMacro = @{
        Title = 'Package List'
        Cql = "label = &quot;integration-services-package&quot; and space = currentSpace() and ancestor = currentContent()";
        PageSize = "100"
        FirstColumn = "Package"
        Headings = "Name,Project,Folder"
        SortBy = "Title"
    }
}

$_integrationServicesPackageConfiguration = @{
    DefaultUserProperties = @("Common Name,Data Source(s),Data Destination(s),Technical Contact(s),Business Contact(s),Customer Contact(s),Related Application(s),Related Department(s)".Split(","))
    ContentMap = @(@($true,$false),$true,$false)
    PageNameSuffix = '(Package)'
}

$_integrationServicesExecutionConfiguration = @{
    StatusColors = @{
        Success = $PC_ConfluenceMacros.Status.Colors.Green
        Running = $PC_ConfluenceMacros.Status.Colors.Blue
        Stopping = $PC_ConfluenceMacros.Status.Colors.Blue
        Completion = $PC_ConfluenceMacros.Status.Colors.Blue
        Pending = $PC_ConfluenceMacros.Status.Colors.Yellow
        Canceled = $PC_ConfluenceMacros.Status.Colors.Red
        Failed = $PC_ConfluenceMacros.Status.Colors.Red
        UnexpectedTerminated = $PC_ConfluenceMacros.Status.Colors.Red
        Created = $PC_ConfluenceMacros.Status.Colors.Grey
    }
    DateTimeFormat = "yyyy-MM-dd HH:mm:ss"
}

$_integrationServicesPageLabels = @{
    Package = 'integration-services-package'
}

#########################################
# integration services package manifest page utilities #
#########################################

function Format-IntegrationServicesPackageManifestConfluencePage($UserSection = (Format-ConfluenceDefaultUserSection)) {
    $pageContents = @()

    # add the page properties report
    $pageContents += Format-ConfluenceHtml -Tag "h1" -Contents $_integrationServicesPackageManifestConfiguration.PagePropertiesMacro.Title
    $pageContents += Format-ConfluencePagePropertiesReportMacro -Cql $_integrationServicesPackageManifestConfiguration.PagePropertiesMacro.Cql -PageSize $_integrationServicesPackageManifestConfiguration.PagePropertiesMacro.PageSize -FirstColumn $_integrationServicesPackageManifestConfiguration.PagePropertiesMacro.FirstColumn -Headings $_integrationServicesPackageManifestConfiguration.PagePropertiesMacro.Headings -SortBy $_integrationServicesPackageManifestConfiguration.PagePropertiesMacro.SortBy

    $map = $ContentMap
    if ($map -eq $null) {$map=@($null,@{Generated=$false;Content=Format-ConfluenceDefaultUserSection})}
    $map[0] = @{Generated=$true;Content=$pageContents}

    # return
    Format-ConfluencePageBase -ContentMap $map
}

function Add-IntegrationServicesPackageManifestConfluencePage($ConfluenceConnection,$SpaceKey,$PageTitle,$AncestorID=-1) {
    $pageContents = Format-IntegrationServicesPackageManifestConfluencePage
    Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $PageTitle -Contents $pageContents -AncestorID $AncestorID
}

function Update-IntegrationServicesPackageManifestConfluencePage($ConfluenceConnection,$Page,$PageTitle) {
    # use an updated title, or keep the old title if a new one is not supplied
    $updateTitle = (&{if($PageTitle -eq "") {$Page.title} else {$PageTitle}})

    # get the content map
    $contentMap = (Get-ConfluenceContentMap -TemplateContent $Page.body.storage.value)

    # render the content
    $pageContents = Format-IntegrationServicesPackageManifestConfluencePage -ContentMap $contentMap

    # post the update
    Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -CurrentVersion $Page.version.number -Title $updateTitle -Contents $pageContents
}

function Publish-IntegrationServicesPackageManifestConfluencePage($ConfluenceConnection,$SpaceKey,$PageTitle,$AncestorID=-1) {
    #look for an existing page
    $page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $PageTitle -Expand @("body.storage","version")
    if ($page) {
        # update the page if it exists
        Update-IntegrationServicesPackageManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -Page $page -PageTitle $PageTitle
    } else {
        #create one if it doesn't
        Add-IntegrationServicesPackageManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -PageTitle $PageTitle -AncestorID $AncestorID
    }
}

###############################################################
#  package formatting                                         #
###############################################################

function Get-IntegrationServicesPackageConfluencePageDefaultTitle($PackageName,$PackageId) {
    "{0} {1}" -f $PackageName,$_integrationServicesPackageConfiguration.PageNameSuffix
}

function Add-IntegrationServicesPackageConfluencePage($ConfluenceConnection,$Catalog,$Package, $SpaceKey, $AncestorID = -1) {
    $pageContents = Format-IntegrationServicesPackageConfluencePage -Package $Package -Catalog $Catalog
    $title = Get-IntegrationServicesPackageConfluencePageDefaultTitle -PackageName $Package.Name -PackageId $Package.PackageId
    $newPage = Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $title -Contents $pageContents -AncestorID $AncestorID
    $newPage
    Add-ConfluencePageLabel -ConfluenceConnection $ConfluenceConnection -PageID $newPage.id -LabelName $_integrationServicesPageLabels.Package
}

function Update-IntegrationServicesPackageConfluencePage($ConfluenceConnection,$Catalog,$Package,$Page,$Title="") {
    # use an updated title, or keep the old title if a new one is not supplied
    $updateTitle = (&{if($Title -eq "") {$Page.title} else {$Title}})

    # get the content map
    $contentMap = (Get-ConfluenceContentMap -TemplateContent $Page.body.storage.value -UserContentMap $_integrationServicesPackageConfiguration.ContentMap)

    # render the content
    $pageContents = Format-IntegrationServicesPackageConfluencePage -Package $Package -ContentMap $contentMap -Catalog $Catalog

    # post the update
    Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -CurrentVersion $Page.version.number -Title $updateTitle -Contents $pageContents

    # determine if we need to add a label as well
    $label = $Page.metadata.labels.results | Where-Object {$_.name -eq $_integrationServicesPageLabels.Package}
    if (-not $label) {
        Add-ConfluencePageLabel -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -LabelName $_integrationServicesPageLabels.Package
    }
}

function Publish-IntegrationServicesPackageConfluencePage($ConfluenceConnection,$Catalog,$Package,$SpaceKey,$Title="",$AncestorID = -1) {
    # search using the supplied title (if one is given) or the name of the job as the title
    $searchTitle = (&{if($Title -eq "") {Get-IntegrationServicesPackageConfluencePageDefaultTitle -PackageName $Package.Name -PackageId $Package.PackageId} else {$Title}})
    
    #look for an existing page
    $page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $searchTitle -Expand @("body.storage","version","metadata.labels")
    if ($page) {
        # update the page if it exists
        Update-IntegrationServicesPackageConfluencePage -ConfluenceConnection $ConfluenceConnection -Page $page -Package $Package -Title $searchTitle -Catalog $Catalog
    } else {
        #create one if it doesn't
        Add-IntegrationServicesPackageConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $searchTitle -AncestorID $AncestorID -Package $Package -Catalog $Catalog
    }
}

function Format-IntegrationServicesPackageConfluencePage($Catalog,$Package,$ContentMap=$null) {
    $userProps = (Format-IntegrationServicesPackageDefaultUserProperties)
    $userContent = (Format-ConfluenceDefaultUserSection)
    $executions = Get-IntegrationServicesPackageExecutions -Catalog $Catalog -PackageName $Package.Name -ProjectName $Package.Parent.Name -FolderName $Package.Parent.Parent.Name

    if ($ContentMap -ne $null) {
        $userProps = $ContentMap[0][0].Content
        $userContent = $ContentMap[1].Content
    }

    $map = @(
            @(
                @{Generated=$false;Content=$userProps},
                @{Generated=$true;Content=(Format-IntegrationServicesPackagePageProperties -Package $Package)}
            ),
            @{Generated=$false;Content=$userContent},
            @{Generated=$true;Content=(Format-IntegrationServicesExecutions -Executions $executions)}
        )
    Format-ConfluencePageBase -ContentMap $map
}

function Format-IntegrationServicesPackageDefaultUserProperties($Title="User Properties") {
    $props = @()

    $propNames = $_integrationServicesPackageConfiguration.DefaultUserProperties
    foreach($name in $propNames) {
        $props += @{"$name"=""}
    }
    $content = (Format-ConfluenceHtml -Tag "h1" -Contents $Title) + (Format-ConfluencePagePropertiesMacro -Properties $props)
    Format-ConfluenceCell -Contents $content
}

function Format-IntegrationServicesPackagePageProperties($Package,$Title="Package Properties") {
    $proj = $Package.Parent
    $folder = $proj.Parent
    $desc = $Package.Description
    $props = @(
        @{Name=$Package.Name},
        @{Project=$proj.Name},
        @{Folder=$folder.Name},
        @{Description=(&{if($desc -ne ""){[System.Net.WebUtility]::HtmlEncode($desc)}else{"N/A"}})},
        @{EntryPoint=(Format-ConfluenceIcon -Icon $Package.EntryPoint)}
    )

    # return
    (Format-ConfluenceHtml -Tag "h1" -Contents $Title) + (Format-ConfluencePagePropertiesMacro -Properties $props)
}

function Get-IntegrationServicesPackageExecutions($Catalog,$FolderName,$ProjectName,$PackageName)
{
    $Catalog.Executions | Where-Object {($_.FolderName -eq $FolderName) -and ($_.ProjectName -eq $ProjectName) -and ($_.PackageName -eq $PackageName)}
}

function Get-IntegrationServicesRecentExecutions($Executions,$Count=50) {
    ($Executions | Sort-Object -Property StartTime -Descending)[0..$Count]
}

###############################################################
#  package execution formatting                               #
###############################################################

function Format-IntegrationServicesExecutions ($Executions,[switch]$IncludePackage) {
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
    #if ($IncludePackage) {$headers += "Project"}
    #if ($IncludePackage) {$headers += "Folder"}
    $rows += Format-ConfluenceHtmlTableHeaderRow -Headers $headers

    # build out the executions rows
    foreach ($e in $Executions) {

        $statusColor = $_integrationServicesExecutionConfiguration.StatusColors.Item($e.Status)
        $statusContent = Format-ConfluenceStatusMacro -Color $statusColor -Text $e.Status

        # Set end time and duration if the job has ended
        $endTime = ""
        if ($e.Completed) {
            $endTime = $e.EndTime.ToString($_integrationServicesExecutionConfiguration.DateTimeFormat)
            $duration = $e.EndTime.Subtract($e.StartTime).ToString("hh\:mm\:ss")
        } else {
            $duration ="N/A"
            $endTime = "N/A"
        }

        $cells = @()
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.Id
        if ($IncludePackage) {$cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.PackageName}
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents (Format-ConfluenceIcon -Icon $e.Completed) -Center $true
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $statusContent
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.StartTime.ToString($_integrationServicesExecutionConfiguration.DateTimeFormat)
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $endTime
        $cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $duration
        #if ($IncludePackage) {$cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.ProjectName}
        #if ($IncludePackage) {$cells += New-ConfluenceHtmlTableCell -Type "td" -Contents $e.FolderName}
        $rows += Format-ConfluenceHtmlTableRow -Cells $cells
    }
    
    # pull it all together
    $title = Format-ConfluenceHtml -Tag "h1" -Contents "Execution(s)"    
    $table = Format-ConfluenceHtmlTable -Rows $rows
    
    # return
    $title + $table
}

function Format-IntegrationServicesExecutionManifestConfluencePage($Executions,$ContentMap=$null) {
    Format-IntegrationServicesExecutions -Executions $Executions -IncludePackage
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

    # get the content map
    $contentMap = (Get-ConfluenceContentMap -TemplateContent $Page.body.storage.value -UserContentMap @($false))

    # render the content
    $pageContents = Format-IntegrationServicesExecutionManifestConfluencePage -Executions $Executions -ContentMap $contentMap

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
