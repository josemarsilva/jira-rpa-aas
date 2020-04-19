# #############################################################################
# filename   : rpa-aas-process.ps1
# description: PowerShell script that process issues
# source-code: https://github.com/josemarsilva/jira-rpa-aas
# references :
#              * https://docs.atlassian.com/software/jira/docs/api/REST/7.11.0/?_ga=2.71147218.359640183.1586629614-2068263516.1586358937#api/2/issue-doTransition
#              * https://adamtheautomator.com/powershell-import-csv-foreach/
#              * https://stackoverflow.com/questions/17325293/invoke-webrequest-post-with-parameters
#              * https://stackoverflow.com/questions/42395638/how-to-use-invoke-restmethod-to-upload-jpg
#              * https://www.reddit.com/r/PowerShell/comments/3s88i8/how_to_create_an_object_which_contains_objects/
#              * https://community.atlassian.com/t5/Jira-questions/400-Bad-Request-when-updating-an-issue-via-REST-API/qaq-p/496467
#              * https://stackoverflow.com/questions/6408904/send-post-request-with-data-specified-in-file-via-curl
#              * https://stackoverflow.com/questions/3044315/how-to-set-the-authorization-header-using-curl
# #############################################################################
#

Write-Host
Write-Host "Starting 'rpa-aas-process.ps1' ..."
$logFileRpaAasProcess = "rpa-aas-process.log"

# Loading (key,value) ...
$configKeyValueCsvFile = "config-key-value.csv"
$objConfigKeyValue = Import-Csv $configKeyValueCsvFile -Delimiter ";" 
$user                        = ( $objConfigKeyValue | Where-Object key -eq "user"                           | Select-Object value )[0].value
$password                    = ( $objConfigKeyValue | Where-Object key -eq "password"                       | Select-Object value )[0].value
$jiraProjectKey              = ( $objConfigKeyValue | Where-Object key -eq "jira-project-key"               | Select-Object value )[0].value
$jiraIssuesCountPerGet       = ( $objConfigKeyValue | Where-Object key -eq "jira-issues-count-per-get"      | Select-Object value )[0].value
$jiraIssuesStatusName        = ( $objConfigKeyValue | Where-Object key -eq "jira-issues-status-name"        | Select-Object value )[0].value
$processWorkerCmd            = ( $objConfigKeyValue | Where-Object key -eq "process-worker-cmd"             | Select-Object value )[0].value
$tmpFileIssuesCsv            = ( $objConfigKeyValue | Where-Object key -eq "tmp-file-issues"                | Select-Object value )[0].value
$tmpFileProcessWorker        = ( $objConfigKeyValue | Where-Object key -eq "tmp-file-process-worker"        | Select-Object value )[0].value
$processWorkerFailureMessage = ( $objConfigKeyValue | Where-Object key -eq "process-worker-failure-message" | Select-Object value )[0].value
Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "User/Password/ProjectKey: " + $user + "/" + $password + "/" + $password + "/" + $jiraProjectKey)

# Clean Temporary Files ...
if (Test-Path $tmpFileProcessWorker) { Remove-Item $tmpFileProcessWorker }

# Header, ContentType, Url ...
$pair = "${user}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue 
    'accept'='application/json' 
}
$headersXAtlassianTokennocheck = @{ Authorization = $basicAuthValue 
    'X-Atlassian-Token'='nocheck'
}
$contentTypeApplicationJson = "application/json"
$contentTypeTextPlain = "text/plain"
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
    Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "IssueId/IssueKey/IssueUrl: " + $issueId + "/" + $issueKey + "/" + $issueSelfUrl )

    # Get issue transitions availables ...
    Write-Host( "    - Get issue transitions")
    $url = $issueSelfUrl + "/transitions?expand=transitions.fields"
    $method = "Get"
    $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentTypeApplicationJson -Method $method
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
    Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "transitionIdConcluir/transitionIdFalhar: " + $transitionIdConcluir + "/" + $transitionIdFalhar )

    # Are Transitions desired available?
    if ($transitionIdConcluir -ne "" -and $transitionIdFalhar -ne "" ) {

        # Add Comment calling process worker ...
        $url = $issueSelfUrl + "/comment"
        $postData = '{ "body": "rpa-aas-process.ps1 is calling ' + $processWorkerCmd.Replace('\','\\') + '" }'

        # Get issue attachments  ...
        Write-Host( "    + Get issue attachments")
        $url = $issueSelfUrl
        $method = "Get"
        $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentTypeApplicationJson -Method $method
        if ($response.fields -ne $null) {
            if ($response.fields.attachment -ne $null) {
                $objIssueAttachments = ( $response.fields.attachment | Select-Object id, filename, content )
                # Iterate issue attachments ...
                $objIssueAttachments | ForEach-Object {
                    # Iterator ...
                    $issueAttachmentId = $_.id 
                    $issueAttachmentFilename = $_.filename
                    $issueAttachmentContent = $_.content
                    Write-Host( "      - attachment(id, filename): (" + $issueAttachmentId + ", " + $issueAttachmentFilename + ")" )
                } # Iterate issue attachments.
            }
        }
        
        $method = "Post"
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "Invoke-RestMethod(url/contentType/method/Body): " + $url + " " + $contentTypeApplicationJson + " " + $method + " " + $postData )
        $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentTypeApplicationJson -Method $method -Body $postData
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "response: " + $response )

        # Call process worker ...
        Write-Host( "    - Call process worker" )
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "processWorkerCmd/issueId/issueKey: " + $processWorkerCmd + "/" + $issueId + "/" + $issueKey )
        cmd.exe /c ( $processWorkerCmd + " " + $issueId + " " + $issueKey ) | Out-File $tmpFileProcessWorker

        # Get results of process worker ...
        $status = Select-String -Path $tmpFileProcessWorker -Pattern "(<status>).*(</status)" | Select-Object -First 1 line
        if ($status -eq $null) {
            $status = ""
        } else {
            $status = $status.Line.Replace("<status>","").Replace("</status>","").Replace(" ","")
        }
        $statusMessage = Select-String -Path $tmpFileProcessWorker -Pattern "(<status-message>).*(</status-message)" | Select-Object -First 1 line
        if ($statusMessage -eq $null -or $statusMessage -eq "null") {
            $statusMessage = ""
        } else {
            $statusMessage = $statusMessage.Line.Replace("<status-message>","").Replace("</status-message>","")
        }
        $packageZip = Select-String -Path $tmpFileProcessWorker -Pattern "(<package-zip>).*(</package-zip)" | Select-Object -First 1 line
        if ($packageZip -eq $null) {
            $packageZip = ""
        } else {
            $packageZip = $packageZip.Line.Replace("<package-zip>","").Replace("</package-zip>","").Replace(" ","")
        }
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "status/packageZip: " + $status + "/" + $packageZip )

        # Set transitionId according to results of process worker ...
        $transitionId = ""
        $transitionId = $transitionIdFalhar
        if ($status -eq "SUCESSO" ) {
            $transitionId = $transitionIdConcluir
        }

        # Add Comment result process worker ...
        $url = $issueSelfUrl + "/comment"
        $postData = '{ "body": "' + $processWorkerCmd.Replace('\','\\') + ' result ' + $status + ' ' + $statusMessage + '" }'
        $method = "Post"
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "Invoke-RestMethod(url/contentType/method/Body): " + $url + " " + $contentTypeApplicationJson + " " + $method + " " + $postData )
        $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentTypeApplicationJson -Method $method -Body $postData
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "response: " + $response )

        # Attach result log ...
        $url = $issueSelfUrl + "/attachments"
        $inFile = "process-worker.tmp"
        $curlCmd = ( 'curl -s -D- -u ' + $user + ':' + $password + ' -X POST -H "X-Atlassian-Token: nocheck" ' + ' -F "file=@' + $inFile + '"' + ' ' + $url )
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "curlCmd: " + $curlCmd )
        $curlCmdResult = cmd.exe /c ( $curlCmd )
        Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "curlCmdResult: " + $curlCmdResult )
        # begin gave-up ...
        # $method = "Post"
        # Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "Invoke-RestMethod(url/contentType/method/Infile): " + $url + " " + $contentTypeTextPlain + " " + $method + " " + $inFile )
        # $response = Invoke-WebRequest $url -Headers $headersXAtlassianTokennocheck -contenttype $contentTypeTextPlain -Method $method -InFile $inFile
        # Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "response: " + $response )
        # end gave-up.

        # Attach result package zip ...
        if ( $packageZip -ne "") {
            $url = $issueSelfUrl + "/attachments"
            $curlCmd = ( 'curl -s -D- -u ' + $user + ':' + $password + ' -X POST -H "X-Atlassian-Token: nocheck" ' + ' -F "file=@' + $packageZip + '"' + ' ' + $url )
            Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "curlCmd: " + $curlCmd )
            $curlCmdResult = cmd.exe /c ( $curlCmd )
            Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "curlCmdResult: " + $curlCmdResult )
        } # ... Attach result package zip

        # Add Comment process worker failure message ...
        if ( $transitionId -eq $transitionIdFalhar ) {
            $url = $issueSelfUrl + "/comment"
            $postData = '{ "body": "' + $processWorkerFailureMessage + '" }'
            $method = "Post"
            Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "Invoke-RestMethod(url/contentType/method/Body): " + $url + " " + $contentTypeApplicationJson + " " + $method + " " + $postData )
            $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentTypeApplicationJson -Method $method -Body $postData
            Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "response: " + $response )
        }

        # Update issue transition ...
        if ( $transitionId -ne "" ) {
            Write-Host( "    - Update issue transition")
            $url = $issueSelfUrl + "/transitions"
            $postData = '{ "transition": {"id": ' +  $transitionId + ' } }'
            $curlCmd = ( 'curl -s -D- -u ' + $user + ':' + $password + ' -X POST -H "Content-Type: application/json" ' + ' --data "' + $postData.Replace('"','\"') + '" ' + ' ' + $url )
            Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "curlCmd: " + $curlCmd )
            $curlCmdResult = cmd.exe /c ( $curlCmd )
            Add-Content $logFileRpaAasProcess ( ( Get-date -f ('yyyy-MM-dd HH:mm:ss').toString() ) + " " + "curlCmdResult: " + $curlCmdResult )
        }

    } # ... Are Transitions desired available?

} # ... Iterates Issues.

Write-Host "Finishing 'rpa-aas-process.ps1'."
Write-Host
