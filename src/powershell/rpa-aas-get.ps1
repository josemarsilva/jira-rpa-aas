# #############################################################################
# filename   : rpa-aas-get.ps1
# description: PowerShell script to get a RPA issue from Jira and invokes another
#              script to process it.
# source-code: https://github.com/josemarsilva/jira-rpa-aas
# references :
#              * https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/
#              * https://developer.atlassian.com/server/jira/platform/jira-rest-api-example-query-issues-6291606/
#              * https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-csv?view=powershell-7
#              * https://stackoverflow.com/questions/12850487/invoke-a-second-script-with-arguments-from-a-script
# #############################################################################
#

Write-Host
Write-Host "Starting 'rpa-aas-get.ps1' ..."
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
$headers = @{ Authorization = $basicAuthValue }
$contentType = "application/json"
$urlProtocolHostnamePort = 'http://localhost:8080'
$orderBy = "key"
$fields = "id,key"
$url = $urlProtocolHostnamePort + "/rest/api/2/search?jql=project=" + $jiraProjectKey + " and status+in+(" + $jiraIssuesStatusName + ")" + "+order+by+" + $orderBy + "&fields=" + $fields + "&maxResults=" + $jiraIssuesCountPerGet

# Get Issues ...
$response = Invoke-RestMethod $url -Headers $headers -contenttype $contentType -Method Get
$response.issues | Select-Object id, key, self | ConvertTo-Csv -NoTypeInformation -Delimiter ';' | Out-File issues.tmp

# Process issues ...
$scriptProcess = ".\rpa-aas-process.ps1"
Invoke-Expression $scriptProcess

Write-Host
Write-Host "Finishing 'rpa-aas-get.ps1'."
Write-Host
