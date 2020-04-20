@ECHO OFF
REM #############################################################################
REM filename   : run-rpa-aas-get-process.bat
REM description: Call both get and process
REM source-code: https://github.com/josemarsilva/jira-rpa-aas
REM references :
REM              * https://stackoverflow.com/questions/13724940/how-to-run-a-powershell-script-from-the-command-line-and-pass-a-directory-as-a-p
REM #############################################################################
REM

CD ..\powershell
powershell.exe -file rpa-aas-get.ps1  
powershell.exe -file rpa-aas-process.ps1
CD ..\win-cmd-batch
