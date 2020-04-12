# #############################################################################
# filename   : get-jira-projects.ps1
# description: Jira API - Request all project
# source-code: https://github.com/josemarsilva/jira-rpa-aas
# references :
#              * https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/
#              * https://stackoverflow.com/questions/27951561/use-invoke-webrequest-with-a-username-and-password-for-basic-authentication-on-t
#              * https://sqljana.wordpress.com/2018/01/11/powershell-tip-specify-select-column-list-attributes-properties-dynamically/
# #############################################################################
#

# Setup ...

# Header ...
$user = "admin"
$password = "admin"
$pair = "${user}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue }
# Content Type ....
$contentType = "application/json"
# Url ...
$url = 'http://localhost:8080/rest/api/2/issue/createmeta'

# Invoke Rest ...
$response = Invoke-RestMethod $url -Headers $headers -contenttype $contentType

# Show response ...
$response.projects | Select-Object id, key, name


