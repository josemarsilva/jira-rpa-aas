@ECHO OFF
REM #############################################################################
REM filename   :
REM              process-worker.bat
REM description:
REM              Batch file that implements the RPA (Robot Process Automation)
REM parameters :
REM              - %1: IssueId
REM              - %2: IssueKey
REM source-code:
REM              https://github.com/josemarsilva/jira-rpa-aas
REM references :
REM              https://stackoverflow.com/questions/13724940/how-to-run-a-powershell-script-from-the-command-line-and-pass-a-directory-as-a-p
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
REM ECHO   + List directory   :
REM dir /b /s


ECHO.
ECHO Step-2: Check attachments 
ECHO.

SET INPUT_ATTACH_FILENAME=remote-windows-command-script.rpa
SET STATUS_MESSAGE_COMPL= 
IF NOT EXIST ".\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%" (
	SET STATUS_MESSAGE_COMPL=Arquivo anexo '%INPUT_ATTACH_FILENAME%' nao foi localizado.
	GOTO PROCESS_FAIL
)


ECHO.
ECHO Step-3-1-1: Type attachment file
ECHO.
TYPE .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%
ECHO.

ECHO.
ECHO Step-3-1-2: Process attachment file
ECHO.
COPY /Y .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME% .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.bat
CALL .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.bat > .\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.log
ECHO.


:PROCESS_SUCCESS

ECHO.
ECHO Step-3-1-3: Sucesso no processamento
ECHO.
ECHO ^<status^>SUCESSO^</status^>
ECHO ^<status-message^>SUCESSO no processamento automatizado pelo RPA. ^</status-message^>
ECHO ^<package-zip^>.\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.log^</package-zip^>

GOTO PROCESS_DONE

:PROCESS_FAIL

ECHO.
ECHO Step-3-2-1: Falha no processamento
ECHO.
ECHO ^<status^>FALHA^</status^>
ECHO ^<status-message^>FALHA no processamento automatizado pelo RPA. %STATUS_MESSAGE_COMPL% ^</status-message^>
ECHO ^<package-zip^>.\issue-attachments-tmp\%1\%INPUT_ATTACH_FILENAME%.log^</package-zip^>

GOTO PROCESS_DONE

:PROCESS_DONE

ECHO.
ECHO ... Finishing 'process-worker.bat'
ECHO.
