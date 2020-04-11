# #############################################################################
# filename   : get-config-key-value-csv.ps1
# description: Powrshell sample of get config key values from (.csv)
# source-code: https://github.com/josemarsilva/jira-rpa-aas
# references :
#              * https://adamtheautomator.com/powershell-import-csv-foreach/
#              * https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-csv?view=powershell-7
#              * https://stackoverflow.com/questions/35334233/filtering-output-using-where-object-in-powershell
# #############################################################################
#

# Setup ...
$configKeyValueCsvFile = "config-key-value.csv"

# Loading (key,value) ...
$objConfigKeyValue = Import-Csv $configKeyValueCsvFile -Delimiter ";" 

# Getting corresponding (key,value) ...
$user           = ( $objConfigKeyValue | Where-Object key -eq "user"             | Select-Object value )[0].value
$password       = ( $objConfigKeyValue | Where-Object key -eq "password"         | Select-Object value )[0].value
$jiraProjectKey = ( $objConfigKeyValue | Where-Object key -eq "jira-project-key" | Select-Object value )[0].value

# Show configuration ...

Write-Host
Write-Host ( "(user, password, jiraProject): " + $user + ", " + $password + ", " + $jiraProjectKey )
Write-Host

$objConfigKeyValue

