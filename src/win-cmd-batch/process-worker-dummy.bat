@ECHO OFF
ECHO.
ECHO Starting 'process-worker.bat' ...
ECHO.
ECHO   - Arg's: %1 %2 %3 %4 %5 %6 %7 %8
ECHO   - IssueId          : %1
ECHO   - IssueKey         : %2
ECHO   - Data             : %DATE%
ECHO   - Hora             : %TIME%
ECHO   + Current directory:
CD
ECHO   + List directory   :
dir
ECHO.
ECHO ^<status^>FAIL^</status^>
ECHO ^<status-message^>Falha^</status-message^>
ECHO ^<package-zip^>C:\GitHome\ws-github-01\jira-rpa-aas\src\powershell\rpa-aas-process.log^</package-zip^>
ECHO.
ECHO Finishing 'process-worker.bat'.
ECHO.
