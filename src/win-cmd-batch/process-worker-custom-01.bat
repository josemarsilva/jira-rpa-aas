@ECHO OFF
REM #############################################################################
REM filename   : process-worker-custom-01.bat
REM description: 
REM parameters :
REM              * %1: IssueId
REM              * %2: IssueKey
REM source-code: https://github.com/josemarsilva/jira-rpa-aas
REM references :
REM              * https://stackoverflow.com/questions/13724940/how-to-run-a-powershell-script-from-the-command-line-and-pass-a-directory-as-a-p
REM #############################################################################
REM

SET BASE_PATH_PROCESS_WORKER_SERVICE=C:\GitHome\ws-brad-01\brad-descaract-dados
SET BASE_PATH_ANEXO_ISSUE=..\powershell
SET PROCESS_WORKER_SERVICE=INDEFINIDO

ECHO.
ECHO Step-1: Getting attachments ...
ECHO.
IF EXIST "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1\sqlloader_arquivos_x_book.csv" (
	SET PROCESS_WORKER_SERVICE=ARQ
)
IF EXIST "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1\sqlloader_db2_param_geracao.csv" (
	SET PROCESS_WORKER_SERVICE=DB2
)

ECHO.
ECHO Step-2: Calling service based on attachments ...
ECHO.
IF "%PROCESS_WORKER_SERVICE%" == "ARQ" (
	ECHO Step-2.1: run_all_in_one_arq.bat
	ECHO.
	ECHO Step-2.1.a: Preparando arquivos de parametros ...
	ECHO.
	DEL /Q %BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_arquivos_x_book.csv
	COPY "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1\sqlloader_arquivos_x_book.csv" "%BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_arquivos_x_book.csv"
	DEL /Q %BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_books.csv
	IF EXIST "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1\sqlloader_books.csv" (
		COPY "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1\sqlloader_books.csv" "%BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_books.csv"
	) ELSE (
		ECHO book;record_length;field_name;field_type;field_start;field_finish;field_length > "%BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_books.csv"
	)
	DEL /Q /S "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1"
	RD "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1"
	ECHO.
	ECHO Step-2.1.b: Executando ...
	ECHO.
	CD %BASE_PATH_PROCESS_WORKER_SERVICE%\src\sql-custom-01
	CALL run_all_in_one_arq.bat %1
) ELSE (
	IF "%PROCESS_WORKER_SERVICE%" == "DB2"  (
		ECHO Step-2.2: CD %BASE_PATH_PROCESS_WORKER_SERVICE%\src\sql-custom-01 ; CALL run_all_in_one_db2.bat
		ECHO.
		ECHO Step-2.1.b: Preparando arquivos de parametros ...
		DEL /Q %BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_db2_param_geracao.csv
		COPY "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1\sqlloader_db2_param_geracao.csv" "%BASE_PATH_PROCESS_WORKER_SERVICE%\gitignore\sqlloader_db2_param_geracao.csv"
		DEL /Q /S "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1"
		RD "%BASE_PATH_ANEXO_ISSUE%\issue-attachments-tmp\%1"
		ECHO.
		ECHO Step-2.2.b: Executando ...
		ECHO.
		CD %BASE_PATH_PROCESS_WORKER_SERVICE%\src\sql-custom-01
		CALL run_all_in_one_db2.bat %1
	) ELSE (
		ECHO Step-2.3: Process Worker Indefinido
		ECHO.
		ECHO ^<status^>FALHA^</status^>
		ECHO ^<status-message^>process-worker-custom-01.bat nao pode determinar o servico a ser executado. Confira os arquivos anexados. Em caso de duvida consulte a documentacao anexada ^</status-message^>
		ECHO ^<package-zip^>C:\GitHome\ws-brad-01\brad-descaract-dados\gitignore\doc.zip^</package-zip^>
		ECHO.
	)
)
