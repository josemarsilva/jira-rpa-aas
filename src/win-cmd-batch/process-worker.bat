@ECHO OFF
REM #############################################################################
REM filename   : * process-worker.bat
REM description: 
REM parameters :
REM              * %1: IssueId
REM              * %2: IssueKey
REM source-code: * https://github.com/josemarsilva/jira-rpa-aas
REM references :
REM              * https://stackoverflow.com/questions/13724940/how-to-run-a-powershell-script-from-the-command-line-and-pass-a-directory-as-a-p
REM #############################################################################
REM

ECHO.
ECHO Starting 'process-worker.bat' ...
ECHO.

ECHO.
ECHO Step-1: Debug current arguments
ECHO.
ECHO   - Arg's: %1 %2 %3 %4 %5 %6 %7 %8
ECHO   - IssueId          : %1
ECHO   - IssueKey         : %2
ECHO   - Data             : %DATE%
ECHO   - Hora             : %TIME%
ECHO   + Current directory:
CD
ECHO   + List directory   :
dir /b


ECHO.
ECHO Step-2: Check attachments 
ECHO.

SET INPUT_ATTACH_FILENAME=remote-windows-command-script.rpa
IF NOT EXIST ".\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%" (
	GOTO PROCESS_FAIL
)


ECHO.
ECHO Step-3: Type attachment file
ECHO.
TYPE .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%
ECHO.

ECHO.
ECHO Step-4: Process attachment file
ECHO.
COPY /Y .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME% .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.bat
CALL .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.bat > .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.log
ECHO.


:PROCESS_SUCCESS

ECHO.
ECHO Step-5.1: Sucesso no processamento
ECHO.
ECHO ^<status^>SUCESSO^</status^>
ECHO ^<status-message^>SUCESSO no processado com sucesso^</status-message^>
ECHO ^<package-zip^>.\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.log^</package-zip^>

GOTO PROCESS_DONE

:PROCESS_FAIL

ECHO.
ECHO Step-5.2: Sucesso no processamento
ECHO.
ECHO ^<status^>FALHA^</status^>
ECHO ^<status-message^>Falha no processado com sucesso^</status-message^>
ECHO ^<package-zip^>.\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.log^</package-zip^>

GOTO PROCESS_DONE

:PROCESS_DONE

ECHO.
ECHO ... Finishing 'process-worker.bat'
ECHO.
