@ECHO OFF
SET BASE_PATH_PROCESS_WORKER_SERVICE=C:\GitHome\ws-github-01\descaract-dados
SET BASE_PATH_ANEXO_ISSUE=..\powershell
SET PROCESS_WORKER_SERVICE=INDEFINIDO

ECHO.
ECHO Step-1: Getting attachments ...
ECHO.
IF EXIST "%BASE_PATH_ANEXO_ISSUE%\modo_arq.tmp" (
	SET PROCESS_WORKER_SERVICE=ARQ
)
IF EXIST "%BASE_PATH_ANEXO_ISSUE%\modo_db2.tmp" (
	SET PROCESS_WORKER_SERVICE=DB2
)

ECHO.
ECHO Step-2: Calling service based on attachments ...
ECHO.
IF "%PROCESS_WORKER_SERVICE%" == "ARQ" (
	ECHO.
	ECHO Step-3.a: run_all_in_one_arq.bat
	ECHO.
	CD %BASE_PATH_PROCESS_WORKER_SERVICE%\src\sql-custom-01
	CALL run_all_in_one_arq.bat
) ELSE (
	IF "%PROCESS_WORKER_SERVICE%" == "DB2"  (
		ECHO.
		ECHO Step-3.b: CD %BASE_PATH_PROCESS_WORKER_SERVICE%\src\sql-custom-01 ; CALL run_all_in_one_db2.bat
		ECHO.
		CD %BASE_PATH_PROCESS_WORKER_SERVICE%\src\sql-custom-01
		CALL run_all_in_one_db2.bat
	) ELSE (
		ECHO.
		ECHO Step-3.c: Process Worker Indefinido
		ECHO.
		ECHO ^<status^>FALHA^</status^>
		ECHO ^<status-message^>process-worker-custom-01.bat nao pode determinar o servico a ser executado. Consulte https://github.com/josemarsilva/jira-rpa-aas ^</status-message^>
		ECHO ^<package-zip^>^</package-zip^>
		ECHO.
	)
)
