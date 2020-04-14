# #############################################################################
# filename   : rpa-aas-process.ps1
# description: PowerShell script that process issues
# source-code: https://github.com/josemarsilva/jira-rpa-aas
# references :
#              * https://docs.atlassian.com/software/jira/docs/api/REST/7.11.0/?_ga=2.71147218.359640183.1586629614-2068263516.1586358937#api/2/issue-doTransition
#              * https://adamtheautomator.com/powershell-import-csv-foreach/
#              * https://stackoverflow.com/questions/17325293/invoke-webrequest-post-with-parameters
#              * https://www.reddit.com/r/PowerShell/comments/3s88i8/how_to_create_an_object_which_contains_objects/
#              * https://community.atlassian.com/t5/Jira-questions/400-Bad-Request-when-updating-an-issue-via-REST-API/qaq-p/496467
#              * https://stackoverflow.com/questions/6408904/send-post-request-with-data-specified-in-file-via-curl
#              * https://stackoverflow.com/questions/3044315/how-to-set-the-authorization-header-using-curl
# #############################################################################
#

Write-Host
Write-Host "Starting 'rpa-aas-process.ps1' ..."
Write-Host

# Loading (key,value) ...
$configKeyValueCsvFile = "config-key-value.csv"
$objConfigKeyValue = Import-Csv $configKeyValueCsvFile -Delimiter ";" 
$user                  = ( $objConfigKeyValue | Where-Object key -eq "user"                      | Select-Object value )[0].value
$password              = ( $objConfigKeyValue | Where-Object key -eq "password"                  | Select-Object value )[0].value
$jiraProjectKey        = ( $objConfigKeyValue | Where-Object key -eq "jira-project-key"          | Select-Object value )[0].value
$jiraIssuesCountPerGet = ( $objConfigKeyValue | Where-Object key -eq "jira-issues-count-per-get" | Select-Object value )[0].value
$jiraIssuesStatusName  = ( $objConfigKeyValue | Where-Object key -eq "jira-issues-status-name"   | Select-Object value )[0].value
$processWorkerCmd      = ( $objConfigKeyValue | Where-Object key -eq "process-worker-cmd"        | Select-Object value )[0].value
$tmpFileIssuesCsv      = ( $objConfigKeyValue | Where-Object key -eq "tmp-file-issues"           | Select-Object value )[0].value
$tmpFileProcessWorker  = ( $objConfigKeyValue | Where-Object key -eq "tmp-file-process-worker"   | Select-Object value )[0].value
$tmpFileIssuesUpdate   = ( $objConfigKeyValue | Where-Object key -eq "tmp-file-issues-update"    | Select-Object value )[0].value

# Clean Temporary Files ...
if (Test-Path $tmpFileProcessWorker) { Remove-Item $tmpFileProcessWorker }
if (Test-Path $tmpFileIssuesUpdate)  { Remove-Item $tmpFileIssuesUpdate }

# Header, ContentType, Url ...
$user = "admin"
$password = "admin"
$pair = "${user}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue 
    'accept'='application/json' 
}
$contentType = "application/json"
$urlProtocolHostnamePort = 'http://localhost:8080'

# Loading Issues  ...
$objIssues = Import-Csv $tmpFileIssuesCsv -Delimiter ";" 

# Iterates Issues  ...
$objIssues | ForEach-Object {

    # Iterator ...
    $issueId = $_.id 
    $issueKey = $_.key
    $issueSelfUrl = $_.self
    Write-Host( "  + Issue(id,key): (" + $issueId + ", " + $issueKey + ")" )

    # Get issue transitions availables ...
    Write-Host( "    - Get issue transitions")
    $url = $issueSelfUrl + "/transitions?expand=transitions.fields"
    $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentType -Method Get
    $transitionIdConcluir = ""
    $objTransitionConcluir = ( $response.transitions | Select-Object id, name | Where-Object name -eq "Concluir" | Select-Object id )
    if (!$objTransitionConcluir) {
        Write-Host( "      * Failed! Transition to 'Concluir' can't be done!") 
    } else { 
        $transitionIdConcluir = $objTransitionConcluir[0].id.ToString()
    }
    $transitionIdFalhar = ""
    $objTransitionFalhar = ( $response.transitions | Select-Object id, name | Where-Object name -eq "Falhar"   | Select-Object id )
    if (!$objTransitionFalhar)   { 
        Write-Host( "      * Failed! Transition to 'Falhar' can't be done!")
    } else { 
        $transitionIdFalhar   = $objTransitionFalhar[0].id.ToString()
    }

    # Transitions not failed ?
    if ($transitionIdConcluir -ne "" -and $transitionIdFalhar -ne "" ) {

        # Call process worker ...
        Write-Host( "    - Call process worker ..." )
        cmd.exe /c ( $processWorkerCmd + " " + $issueId + " " + $issueKey ) | Out-File $tmpFileProcessWorker

        # Get results of process worker ...
        $status = Select-String -Path $tmpFileProcessWorker -Pattern "(<status>).*(</status)" | Select-Object -First 1 line
        if ($status -eq $null) {
            $status = ""
        } else {
            $status = $status.Line.Replace("<status>","").Replace("</status>","").Replace(" ","")
        }
        $packageZip = Select-String -Path $tmpFileProcessWorker -Pattern "(<package-zip>).*(</package-zip)" | Select-Object -First 1 line
        if ($packageZip -eq $null) {
            $packageZip = ""
        } else {
            $packageZip = $packageZip.Line.Replace("<package-zip>","").Replace("</package-zip>","").Replace(" ","")
        }

        # Set transitionId according to results of process worker ...
        $transitionId = ""
        $transitionId = $transitionIdFalhar
        if ($status -eq "" ) {
            $transitionId = $transitionIdConcluir
        }


        # Update issue transition (new status) ...
        if ( $transitionId -ne "" ) {
            Write-Host( "    - Update issue transition (new status)")
            $url = $issueSelfUrl + "/transitions"
            $postData = '{ "transition": {"id": ' +  $transitionId + ' },  "update": { "comment": [ { "add": {  "body": "rpa-aas-process.ps1 is updating process-worker.bat results!" } } ] } }'
            $curlCmd = ( 'curl -s -D- -u ' + $user + ':' + $password + ' -X POST -H "Content-Type: application/json" ' + ' --data "' + $postData.Replace('"','\"') + '" ' + ' ' + $url )
            Add-Content $tmpFileIssuesUpdate ""
            Add-Content $tmpFileIssuesUpdate ( "issueId:" + $issueId  + ", issueKey: " + $issueKey + ", issueSelfUrl" + $issueSelfUrl)
            Add-Content $tmpFileIssuesUpdate ""
            Add-Content $tmpFileIssuesUpdate $curlCmd
            Add-Content $tmpFileIssuesUpdate ""
            $curlCmdResult = cmd.exe /c ( $curlCmd )
            Add-Content $tmpFileIssuesUpdate $curlCmdResult
            Add-Content $tmpFileIssuesUpdate ""


    }


    }

}

Write-Host
Write-Host "Finishing 'rpa-aas-process.ps1'."
Write-Host
