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
$IssuesCsvFile = "issues.tmp"
$objIssues = Import-Csv $IssuesCsvFile -Delimiter ";" 


# Iterates Issues  ...
$objIssues | ForEach-Object {

    # itens
    $issueId = $_.id 
    $issueKey = $_.key
    $issueSelfUrl = $_.self
    Write-Host( "  + Issue(id,key): (" + $issueId + ", " + $issueKey + ")" )

    # Get issue transitions ...
    Write-Host( "    - Get issue transitions")
    $url = $issueSelfUrl + "/transitions?expand=transitions.fields"
    $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentType -Method Get
    $transitionIdConcluir = ( $response.transitions | Select-Object id, name | Where-Object name -eq "Concluir" | Select-Object id )[0].id
    $transitionIdFalhar   = ( $response.transitions | Select-Object id, name | Where-Object name -eq "Falhar"   | Select-Object id )[0].id

    # Call process worker ...
    Write-Host( "    - call process worker ..." )
    cmd.exe /c ( "..\win-cmd-batch\process-worker.bat" + " " + $issueId + " " + $issueKey )

    # Update issue transition
    Write-Host( "    - Update issue transition")
    $url = $issueSelfUrl + "/transitions"

    $postParams = ConvertFrom-Json ( "{ ""transition"": {""id"": """+  $transitionIdConcluir + """} }" )
    ConvertTo-Json $postParams
    Try {
        $response = Invoke-RestMethod -Method Post -Uri $url -Body $postParams -Headers $headers -contenttype $contentType 
        # $response = Invoke-RestMethod $url -Headers $headers -contenttype $contentType -Method Post -Body $postParams
        $response
    } Catch [System.Net.WebException] { $exception = $_.Exception
        $respstream = $exception.Response.GetResponseStream()
        $sr = new-object System.IO.StreamReader $respstream
        $ErrorResult = $sr.ReadToEnd()
        write-host $ErrorResult 
    }

}


Write-Host
Write-Host "Finishing 'rpa-aas-process.ps1'."
Write-Host
