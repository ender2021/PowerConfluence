Import-Module .\PowerConfluence.psm1 -Force
Import-Module .\ConfluenceCredentials.psm1 -Force

###########################
# useful string libraries #
###########################

$_sqlAgentJobManifestConfiguration = @{
    InfoMacro = @{
        Title = 'Schedule View';
        BodyTemplate = 'Check out the {0} for a summary of execution schedules for these jobs!'
        LinkText = 'Schedule Overview'
    };
    PagePropertiesMacro = @{
        Title = 'Job List'
        Cql = "label = &quot;sql-agent-job&quot; and space = currentSpace() and ancestor = currentContent()";
        PageSize = "100"
        FirstColumn = "Job"
        Headings = "Description,Enabled,Schedules,Steps,Owner,Created,Last Modified"
        SortBy = "Title"
    }
}

$_integrationServicesPackageTemplateStrings = @{
    ExecutionsTableStart = '<h1>Execution(s)</h1><table class="relative-table"><tbody><tr><th>ID</th><th>Completed</th><th>Status</th><th>Start Time</th><th>End Time</th><th>Duration</th></tr>';
    ExecutionsTableEnd = '</tbody></table>';
}

$_pageLabels = @{
    SqlAgentJob = 'sql-agent-job'
}

###################################
# sql agent job various utilities #
###################################

function Get-SqlAgentJobScheduleWithTranslation() {
  Begin {
    #start a list to hold augmented schedule objects
    $translatedSchedules = @()
  }

  Process {
    #iterate over schedules for each job, and build a new schedule object with additional properties
    foreach($SqlAgentJobSchedule in $_ | Get-SqlAgentJobSchedule) {
        
        #give an easier name to the schedule object
        $translated = $SqlAgentJobSchedule
        
        #define some convenient variables we'll be using from the cloned object
        $FrequencyType = $translated.FrequencyTypes
        $FrequencyInterval = $translated.FrequencyInterval
        $FrequencyRecurrenceFactor = $translated.FrequencyRecurrenceFactor
        $FrequencyRelativeInterval = $translated.FrequencyRelativeIntervals
        $ActiveStartDate = $translated.ActiveStartDate
        $FrequencySubDayType = $translated.FrequencySubDayTypes
        $FrequencySubDayInterval = $translated.FrequencySubDayInterval
        $ActiveStartTimeOfDay = $translated.ActiveStartTimeOfDay

        #add new properties to hold derived translations
        $translated | Add-Member -MemberType AliasProperty -Name JobName -Value Parent -Force
        $translated | Add-Member -MemberType AliasProperty -Name ScheduleEnabled -Value IsEnabled -Force
        $translated | Add-Member -MemberType AliasProperty -Name ScheduleName -Value Name -Force
        $translated | Add-Member -MemberType NoteProperty -Name JobEnabled -Value $_.IsEnabled -Force
        $translated | Add-Member -MemberType NoteProperty -Name StartTimeTranslation -Value (Get-Date -Hour $ActiveStartTimeOfDay.Hours -Minute $ActiveStartTimeOfDay.Minutes -Format t) -Force
        $translated | Add-Member -MemberType NoteProperty -Name StartDateTranslation -Value ("beginning " + $ActiveStartDate.ToString("d")) -Force
        $translated | Add-Member -MemberType NoteProperty -Name FrequencyTypeTranslation -Value $FrequencyType.ToString() -Force
        $translated | Add-Member -MemberType NoteProperty -Name FrequencyIntervalTranslation -Value $FrequencyInterval.ToString() -Force
        $translated | Add-Member -MemberType NoteProperty -Name FrequencySubDayTranslation -Value "Once" -Force
        $translated | Add-Member -MemberType NoteProperty -Name FrequencyRecurrenceFactorTranslation -Value $FrequencyType.ToString() -Force
        $translated | Add-Member -MemberType NoteProperty -Name FrequencyRelativeIntervalTranslation -Value $FrequencyRelativeInterval.ToString() -Force
        $translated | Add-Member -MemberType NoteProperty -Name FrequencyTranslation -Value "" -Force
        $translated | Add-Member -MemberType NoteProperty -Name TimingTranslation -Value "" -Force

        #translate frequency values and assign them to the new object
        switch ($FrequencyType) {
            "Daily" {
                #set properties
                $translated.FrequencyTranslation = "Every $FrequencyInterval day(s)"
            }
            "Weekly" {
                #decode the frequency interval to a list of days using bitwise logic (and magic knowledge)
                $days = @()
                if ($FrequencyInterval -band 1) { $days += "Sunday" }
                if ($FrequencyInterval -band 2) { $days += "Monday" }
                if ($FrequencyInterval -band 4) { $days += "Tuesday" }
                if ($FrequencyInterval -band 8) { $days += "Wednesday" }
                if ($FrequencyInterval -band 16) { $days += "Thursday" }
                if ($FrequencyInterval -band 32) { $days += "Friday" }
                if ($FrequencyInterval -band 64) { $days += "Sunday" }

                #set properties
                if($FrequencyRecurrenceFactor -gt 1) { $translated.FrequencyRecurrenceFactorTranslation = "Every $FrequencyRecurrenceFactor weeks" }
                $translated.FrequencyIntervalTranslation = ($days -join ", ")
                $translated.FrequencyTranslation =  $translated.FrequencyRecurrenceFactorTranslation + ", on " + $translated.FrequencyIntervalTranslation
            }
            "Monthly" {
                #set properties
                if($FrequencyRecurrenceFactor -gt 1) { $translated.FrequencyRecurrenceFactorTranslation = "Every $FrequencyRecurrenceFactor months" }
                $translated.FrequencyIntervalTranslation = "day $FrequencyInterval of the month"
                $translated.FrequencyTranslation = $translated.FrequencyRecurrenceFactorTranslation + ", on " + $translated.FrequencyIntervalTranslation
            }
            "MonthlyRelative" {
                #use magic knowledge to decode the frequency interval
                $translated.FrequencyIntervalTranslation = switch ($FrequencyInterval) {
                    1 { "Sunday" }
                    2 { "Monday" }
                    3 { "Tuesday" }
                    4 { "Wednesday" }
                    5 { "Thursday" }
                    6 { "Friday" }
                    7 { "Saturday" }
                    8 { "day" }
                    9 { "weekday" }
                    10 { "weekend day" }
                    default { "Unknown Interval" }
                }

                #set properties
                if($FrequencyRecurrenceFactor -gt 1) {
                    $translated.FrequencyRecurrenceFactorTranslation = "Every $FrequencyRecurrenceFactor months"
                } else {
                    $translated.FrequencyRecurrenceFactorTranslation = "Monthly"
                }
                $translated.FrequencyRelativeIntervalTranslation = $FrequencyRelativeInterval.ToString().ToLower() + " " + $translated.FrequencyIntervalTranslation + " of the month"
                $translated.FrequencyTranslation = $translated.FrequencyRecurrenceFactorTranslation + ", on the " + $translated.FrequencyRelativeIntervalTranslation
            }
            default { $translated.FrequencyTranslation = "Unknown Interval" }
        }

        #translate timing values and assign them to the new object
        if ($FrequencySubDayType -ne "Once") {
            $translated.FrequencySubDayTranslation += " every $FrequencySubDayInterval " + $FrequencySubDayType.ToString().ToLower() + "(s)"
        }
        $translated.TimingTranslation = $translated.FrequencySubDayTranslation + " starting at " + $translated.StartTimeTranslation        
        
        #add the object with the new properties to the return list
        $translatedSchedules += $translated
    }
  }

  End {
    #return
    $translatedSchedules
  }
  
}

function Get-SqlAgentJobStepPackagePath($SqlAgentJobStep) {
    $package = ""
    foreach ($str in $SqlAgentJobStep.Command.Split("/")) {
        if ($str.StartsWith("ISSERVER")) {
            $trimStr = $str.Substring(9)
            $trimStr = $trimStr.Replace('\"','')
            $trimStr = $trimStr.Replace('"','')
            $trimStr = $trimStr.Substring(8)
            $package = $trimStr
            break
        }
    }
    $package
}

#########################################
# sql agent job manifest page utilities #
#########################################

function Format-SqlAgentJobManifestConfluencePage($SchedulePageTitle="", $UserSection = (Format-ConfluenceDefaultUserSection)) {
    $pageContents = @()

    # create info macro
    $infoMacro = $PC_ConfluenceMacros.Info
    $macroParameters = Format-ConfluenceMacroParameters -Parameters @{title=$_sqlAgentJobManifestConfiguration.InfoMacro.Title}
    $link = Format-ConfluencePageLink -TargetPageTitle $SchedulePageTitle -LinkText $_sqlAgentJobManifestConfiguration.InfoMacro.LinkText
    $macroBody = Format-ConfluenceMacroRichTextBody -Content (Format-SimpleHtml -Tag "p" -Contents ($_sqlAgentJobManifestConfiguration.InfoMacro.BodyTemplate -f $link))
    $pageContents += Format-ConfluenceMacro -Name $infoMacro.Name -SchemaVersion $infoMacro.SchemaVersion -ID $infoMacro.ID -Contents ($macroParameters + $macroBody)
    
    # add the page properties report
    $pageContents += Format-SimpleHtml -Tag "h1" -Contents $_sqlAgentJobManifestConfiguration.PagePropertiesMacro.Title
    $pageContents += Format-ConfluencePagePropertiesReportMacro -Cql $_sqlAgentJobManifestConfiguration.PagePropertiesMacro.Cql -PageSize $_sqlAgentJobManifestConfiguration.PagePropertiesMacro.PageSize -FirstColumn $_sqlAgentJobManifestConfiguration.PagePropertiesMacro.FirstColumn -Headings $_sqlAgentJobManifestConfiguration.PagePropertiesMacro.Headings -SortBy $_sqlAgentJobManifestConfiguration.PagePropertiesMacro.SortBy
    
    # done!
    Format-ConfluencePageBase -GeneratedContent $pageContents -UserSection $UserSection    
}

function Add-SqlAgentJobManifestConfluencePage($ConfluenceConnection,$SpaceKey,$PageTitle,$SchedulePageTitle,$AncestorID=-1) {
    $pageContents = Format-SqlAgentJobManifestConfluencePage -SchedulePageTitle $SchedulePageTitle
    Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $PageTitle -Contents $pageContents -AncestorID $AncestorID
}

function Update-SqlAgentJobManifestConfluencePage($ConfluenceConnection,$Page,$PageTitle,$SchedulePageTitle) {
    # use an updated title, or keep the old title if a new one is not supplied
    $updateTitle = (&{if($PageTitle -eq "") {$Page.title} else {$PageTitle}})

    # get the user-generated content
    $userContent = Get-ConfluenceUserContent -TemplateContent $Page.body.storage.value

    # render the content
    $pageContents = Format-SqlAgentJobManifestConfluencePage -SchedulePageTitle $SchedulePageTitle -UserSection $userContent

    # post the update
    Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -CurrentVersion $Page.version.number -Title $updateTitle -Contents $pageContents
}

function Publish-SqlAgentJobManifestConfluencePage($ConfluenceConnection,$SpaceKey,$PageTitle,$SchedulePageTitle,$AncestorID=-1) {
    #look for an existing page
    $page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $PageTitle -Expand @("body.storage","version")
    if ($page) {
        # update the page if it exists
        Update-SqlAgentJobManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -Page $page -PageTitle $PageTitle -SchedulePageTitle $SchedulePageTitle
    } else {
        #create one if it doesn't
        Add-SqlAgentJobManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -PageTitle $PageTitle -SchedulePageTitle $SchedulePageTitle -AncestorID $AncestorID
    }
}

#############################################
# sql agent schedule summary page utilities #
#############################################

function Format-SqlAgentScheduleSummaryConfluencePage($Schedules, $UserSection=(Format-ConfluenceDefaultUserSection)) {
    $rows = @()
    
    # create the header row
    $headerCells = @(
        @{Type="th";Contents="Job Name"},
        @{Type="th";Contents="Job Enabled"},
        @{Type="th";Contents="Schedule Name"},
        @{Type="th";Contents="Schedule Enabled"},
        @{Type="th";Contents="Execution Frequency"},
        @{Type="th";Contents="Execution Time"}
    )    
    $rows += Format-HtmlTableRow -Cells $headerCells

    # build out the schedule rows
    foreach ($schedule in $Schedules) {
        $cells = @(
                @{Type="td";Contents=(Format-ConfluencePageLink -TargetPageTitle $schedule.Parent -LinkText $schedule.Parent)},
                @{Type="td";Contents=(Format-ConfluenceIcon -IconName (&{If($schedule.JobEnabled) {"tick"} Else {"cross"}}));Center=$true},
                @{Type="td";Contents=$schedule.Name},
                @{Type="td";Contents=(Format-ConfluenceIcon -IconName (&{If($schedule.IsEnabled) {"tick"} Else {"cross"}}));Center=$true},
                @{Type="td";Contents=$schedule.FrequencyTranslation},
                @{Type="td";Contents=$schedule.StartTimeTranslation}
            )
        $rows += Format-HtmlTableRow -Cells $cells
    }
    
    # pull it all together
    $title = Format-SimpleHtml -Tag "h1" -Contents "SQL Agent Job Schedule Summary"    
    $table = Format-HtmlTable -Rows $rows
    
    # return
    Format-ConfluencePageBase -GeneratedContent ($title + $table) -UserSection $UserSection    
}

function Add-SqlAgentScheduleSummaryConfluencePage($ConfluenceConnection,$SpaceKey,$AncestorID=-1,$Title="",$Schedules) {
    $pageContents = Format-SqlAgentScheduleSummaryConfluencePage -Schedules $Schedules
    Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $Title -Contents $pageContents -AncestorID $AncestorID
}

function Update-SqlAgentScheduleSummaryConfluencePage($ConfluenceConnection,$Page,$Title="",$Schedules) {
    
    # use an updated title, or keep the old title if a new one is not supplied
    $updateTitle = (&{if($Title -eq "") {$Page.title} else {$Title}})

    # get the user-generated content
    $userContent = Get-ConfluenceUserContent -TemplateContent $Page.body.storage.value

    # render the content
    $pageContents = Format-SqlAgentScheduleSummaryConfluencePage -Schedules $Schedules -UserSection $userContent

    # post the update
    Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -CurrentVersion $Page.version.number -Title $updateTitle -Contents $pageContents
}

function Publish-SqlAgentScheduleSummaryConfluencePage($ConfluenceConnection,$SpaceKey,$Title,$Schedules,$AncestorID=-1) {
    #look for an existing page
    $page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $Title -Expand @("body.storage","version")
    if ($page) {
        # update the page if it exists
        Update-SqlAgentScheduleSummaryConfluencePage -ConfluenceConnection $ConfluenceConnection -Page $page -Schedules $Schedules
    } else {
        #create one if it doesn't
        Add-SqlAgentScheduleSummaryConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $Title -Schedules $Schedules -AncestorID $AncestorID
    }
}

################################
# sql agent job page utilities #
################################

function Format-SqlAgentJobConfluencePageProperties($SqlAgentJob) {
    #define the properties as key-value pairs in an array
    $properties = @(
        @{"SQL Agent Job Name" = $SqlAgentJob.Name}
        @{Description = (&{if($SqlAgentJob.Description -ne ""){[System.Net.WebUtility]::HtmlEncode($SqlAgentJob.Description)}else{"N/A"}})},
        @{Enabled = Format-ConfluenceIcon -IconName (&{If($SqlAgentJob.IsEnabled) {"tick"} Else {"cross"}})},
        @{Schedules = ($SqlAgentJob|Get-SqlAgentJobSchedule|Measure-Object).Count},
        @{Steps = ($SqlAgentJob|Get-SqlAgentJobStep|Measure-Object).Count},
        @{Owner = $SqlAgentJob.OwnerLoginName},
        @{Created = Format-ConfluenceDate($SqlAgentJob.DateCreated)},
        @{"Last Modified" = Format-ConfluenceDate($SqlAgentJob.DateLastModified)}
    )
    Format-ConfluencePagePropertiesBase -Properties $properties
}

function Format-SqlAgentJobConfluencePageSchedules($SqlAgentJob) {
    $rows = @()

    # create the header row
    $headerCells = @(
        @{Type="th";Contents="Schedule Name"},
        @{Type="th";Contents="Enabled"},
        @{Type="th";Contents="Execution Frequency"},
        @{Type="th";Contents="Execution Time"},
        @{Type="th";Contents="Activation Date"},
        @{Type="th";Contents="Date Created"}
    )    
    $rows += Format-HtmlTableRow -Cells $headerCells

    # create the schedule rows
    $schedules = $SqlAgentJob | Get-SqlAgentJobScheduleWithTranslation
    foreach ($schedule in $schedules) {
        $cells = @(
            @{Type="td";Contents=$schedule.Name},
            @{Type="td";Contents=(Format-ConfluenceIcon -IconName (&{If($schedule.IsEnabled) {"tick"} Else {"cross"}}))},
            @{Type="td";Contents=$schedule.FrequencyTranslation},
            @{Type="td";Contents=$schedule.StartTimeTranslation},
            @{Type="td";Contents=Format-ConfluenceDate($schedule.ActiveStartDate)}
            @{Type="td";Contents=Format-ConfluenceDate($schedule.DateCreated)}
        )
        $rows += Format-HtmlTableRow -Cells $cells
    }

    # return the title and the table
    (Format-SimpleHtml -Tag "h1" -Contents "Schedule(s)") + (Format-HtmlTable -Rows $rows)
}

function Format-SqlAgentJobConfluencePageSteps($SqlAgentJob) {
    $rows = @()

    # create the header row
    $headerCells = @(
        @{Type="th";Contents="#"},
        @{Type="th";Contents="Step Name"},
        @{Type="th";Contents="Step Type"},
        @{Type="th";Contents="Package"},
        @{Type="th";Contents="Package Path"},
        @{Type="th";Contents="On Fail"},
        @{Type="th";Contents="On Success"}
    )    
    $rows += Format-HtmlTableRow -Cells $headerCells

    # create the step rows
    $steps = $SqlAgentJob | Get-SqlAgentJobStep
    foreach ($step in $steps) {
        # prepare some package details
        $packageFullPath = Get-SqlAgentJobStepPackagePath($step)
        $packagePathArr = $packageFullPath.Split('\')
        $failAction = $($step.OnFailAction -csplit "(?<=.)(?=[A-Z])")
        $successAction = $($step.OnSuccessAction -csplit "(?<=.)(?=[A-Z])")

        # create the cells
        $cells = @(
            @{Type="td";Contents="" + $step.ID + (&{If($SqlAgentJob.StartStepID -eq $step.ID) {" " + (Format-ConfluenceIcon -IconName "yellow-star")} Else {""}})},
            @{Type="td";Contents=$step.Name},
            @{Type="td";Contents=$step.SubSystem},
            @{Type="td";Contents=$packagePathArr[2]},
            @{Type="td";Contents=$packagePathArr[0] + '\' + $packagePathArr[1]},
            @{Type="td";Contents="$failAction"},
            @{Type="td";Contents="$successAction"}
        )

        # render the row and add it to the list
        $rows += Format-HtmlTableRow -Cells $cells
    }

    # build the return string
    $header = Format-SimpleHtml -Tag "h1" -Contents "Step(s)"
    $note = Format-SimpleHtml -Tag "p" -Contents ((Format-ConfluenceIcon -IconName "yellow-star") + "&nbsp;= First Step")
    $table = Format-HtmlTable -Rows $rows

    # return
    "$header$note$table"
}

function Format-SqlAgentJobConfluencePage($SqlAgentJob, $UserSection = (Format-ConfluenceDefaultUserSection)) {
    $pageContent = @()
    $pageContent += Format-SqlAgentJobConfluencePageProperties($SqlAgentJob)
    $pageContent += Format-SqlAgentJobConfluencePageSchedules($SqlAgentJob)
    $pageContent += Format-SqlAgentJobConfluencePageSteps($SqlAgentJob)
    Format-ConfluencePageBase -GeneratedContent $pageContent -UserSection $UserSection
}

function Add-SqlAgentJobConfluencePage($ConfluenceConnection,$SqlAgentJob, $SpaceKey, $AncestorID = -1) {
    $pageContents = Format-SqlAgentJobConfluencePage -SqlAgentJob $SqlAgentJob
    $title = $SqlAgentJob.Name
    $newPage = Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $title -Contents $pageContents -AncestorID $AncestorID
    $newPage
    Add-ConfluencePageLabel -ConfluenceConnection $ConfluenceConnection -PageID $newPage.id -LabelName $_pageLabels.SqlAgentJob
}

function Update-SqlAgentJobConfluencePage($ConfluenceConnection,$SqlAgentJob,$Page,$Title="") {
    # use an updated title, or keep the old title if a new one is not supplied
    $updateTitle = (&{if($Title -eq "") {$Page.title} else {$Title}})

    # get the user-generated content
    $userContent = Get-ConfluenceUserContent -TemplateContent $Page.body.storage.value

    # render the content
    $pageContents = Format-SqlAgentJobConfluencePage -SqlAgentJob $SqlAgentJob -UserSection $userContent

    # post the update
    Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -CurrentVersion $Page.version.number -Title $updateTitle -Contents $pageContents

    # determine if we need to add a label as well
    $label = $Page.metadata.labels.results | Where-Object {$_.name -eq $_pageLabels.SqlAgentJob}
    if (-not $label) {
        Add-ConfluencePageLabel -ConfluenceConnection $ConfluenceConnection -PageID $Page.id -LabelName $_pageLabels.SqlAgentJob
    }
}

function Publish-SqlAgentJobConfluencePage($ConfluenceConnection,$SqlAgentJob,$SpaceKey,$Title="",$AncestorID = -1) {
    # search using the supplied title (if one is given) or the name of the job as the title
    $searchTitle = (&{if($Title -eq "") {$SqlAgentJob.Name} else {$Title}})
    
    #look for an existing page
    $page = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $searchTitle -Expand @("body.storage","version","metadata.labels")
    if ($page) {
        # update the page if it exists
        Update-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -Page $page -SqlAgentJob $SqlAgentJob -Title $searchTitle
    } else {
        #create one if it doesn't
        Add-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $SpaceKey -Title $searchTitle -AncestorID $AncestorID -SqlAgentJob $SqlAgentJob
    }
}

########################################
#                                      #
#  DO STUFF WITH FUNCTIONS BELOW HERE  #
#                                      #
########################################

#########################
# common API parameters #
#########################

$ConfluenceConnection = Get-ConfluenceConnection -UserName $Credentials.UserName -ApiToken $Credentials.ApiToken -HostName $Credentials.HostName
$SqlAgentServerDev = $Credentials.SqlAgentServerDev
$spaceKey = "GSD"

########################################
# refresh a full SqlAgentJob manifest  #
########################################

<#
$manifest = Publish-SqlAgentJobManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -PageTitle "SQL Agent Jobs - GradDiv DEV" -SchedulePageTitle "Job Schedule - GradDiv DEV Jobs"

$jobs = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev | ? { $_.Name.StartsWith("GradDiv", "CurrentCultureIgnoreCase") }

$schedules = $jobs | Get-SqlAgentJobScheduleWithTranslation | Sort-Object -Property @{e={$_.JobEnabled -and $_.IsEnabled}; a=0},@{e={$_.JobEnabled}; a=0},FrequencyTypes,FrequencyRecurrenceFactor,ActiveStartTimeOfDay,Parent
$schedulePage = Publish-SqlAgentScheduleSummaryConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title $title -Schedules $schedules -AncestorID $manifest.id

foreach ($job in $jobs) {
    Publish-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SqlAgentJob $job -SpaceKey $spaceKey -AncestorID $manifest.id
}
#>

########################################
# refresh a SqlAgentJob manifest page  #
########################################


Publish-SqlAgentJobManifestConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -PageTitle "SQL Agent Jobs - GradDiv DEV" -SchedulePageTitle "Job Schedule - GradDiv DEV Jobs"
#>

###########################################
# (re)generate a set of SqlAgentJob pages #
###########################################

<#
$jobs = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev | ? { $_.Name.StartsWith("GradDiv", "CurrentCultureIgnoreCase") }
foreach ($job in $jobs) {
    Publish-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SqlAgentJob $job -SpaceKey $spaceKey -AncestorID 312246349
}
#>

########################################
# refresh a SqlAgentJob profile page   #
########################################

<#
$job = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev -Name "GradDiv - Load X Tables"
Publish-SqlAgentJobConfluencePage -ConfluenceConnection $ConfluenceConnection -SqlAgentJob $job -SpaceKey $spaceKey -AncestorID 312443414
#>

########################################
# refresh a job schedule overview page #
########################################

<#
$title = "Job Schedule - GradDiv DEV Jobs"
$schedules = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev | ? { $_.Name.StartsWith("GradDiv", "CurrentCultureIgnoreCase") }  | Get-SqlAgentJobScheduleWithTranslation | Sort-Object -Property @{e={$_.JobEnabled -and $_.IsEnabled}; a=0},@{e={$_.JobEnabled}; a=0},FrequencyTypes,FrequencyRecurrenceFactor,ActiveStartTimeOfDay,Parent
Publish-SqlAgentScheduleSummaryConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title $title -Schedules $schedules
#>

############################
# update a Confluence page #
############################

#$results = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID 312377422 -Expand @("body.storage","version")
#Get-ConfluenceUserContent -TemplateContent $results.body.storage.value
#Update-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID 312377422 -CurrentVersion $results.version.number -Title ($results.title.Substring(0,$results.title.IndexOf("(")) + " (v. " + ($results.version.number + 1) + ")") -Contents $results.body.storage.value


#########################
# get a Confluence page #
#########################

<#
$results = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title "Job Schedule - GradDiv DEV Jobs" -Expand @("metadata.labels")
#$results = Get-ConfluencePage -ConfluenceConnection $ConfluenceConnection -PageID 312377422
$filtered
#>

########################################
# post an agent job page to Confluence #
########################################

<#
$job = Get-SqlAgentJob -ServerInstance $SqlAgentServerDev -Name "GradDiv - Load X Tables"
$pageContents = Format-SqlAgentJobConfluencePage($job)
$title = "GradDiv - Load X Tables"
Add-ConfluencePage -ConfluenceConnection $ConfluenceConnection -SpaceKey $spaceKey -Title $title -Contents $pageContents -AncestorID 312246349
#>