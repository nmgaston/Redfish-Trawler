@REM enter directory
@ECHO OFF

IF "%~1"=="clean" (
    echo Removing directory .venv
    RMDIR .venv /S /Q
)

IF NOT EXIST ".venv\Scripts\python.exe" (
    ECHO Creating virtual environment
    call py.exe -m venv .venv 
    call ".venv\Scripts\activate.bat"
    call pip install -r requirements.txt
)

ECHO Entering virtual environment
call ".venv\Scripts\activate.bat"

call py.exe .\redfish_trawler.py
