@REM enter directory
@ECHO OFF

chdir redfish-trawler-frontend

IF "%~1"=="clean" (
    echo Removing directory node_modules
    RMDIR node_modules /S /Q
)

WHERE npm
IF %ERRORLEVEL% NEQ 0 (
    ECHO npm does not seem to be available.
    exit 1
)

call npm install

IF %ERRORLEVEL% NEQ 0 (
    ECHO npm packages failed to install.
    exit 1
)

ECHO npm packages successfully installed.

call npm run build