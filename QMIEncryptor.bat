@echo off
:: Setting up arguments in variables 
setlocal EnableDelayedExpansion
set "Path=%Path%;%cd%\Files"
set _mode=%~1
set _pathinput=%~2
set _pathoutput=%~3

if "%_pathoutput%"=="" (set _func=equ & goto _clearPath) else (set _func=diff & goto _funcCaller)

:_clearPath
for %%I in (%_pathinput%) do set tempname1=%%~I
:pathClearerLoop
set tempname2=%tempname1:*\=%
if not %tempname1% == %tempname2% ( set tempname1=%tempname2% & goto pathClearerLoop )
set _filename=%tempname1: =%

echo %_filename%> tempfile.tmp
for /F "tokens=* usebackq" %%F in (`list "tempfile.tmp" /il 0`) do (
set _filenameLng=%%F
)
del tempfile.tmp
set _foldpath=!_pathinput:~0,-%_filenameLng%!
:: Check the mode (decrypt/encrypt)
:_funcCaller
if %_mode%==-e (if %_func%==diff (goto diffEncrypt) else (if %_func%==equ goto encrypt))
if %_mode%==-d (if %_func%==diff (goto diffDecrypt) else (if %_func%==equ goto decrypt))
set %ERRORLEVEL%=1
goto END
:: Encryption functions
:encrypt
set /a _filenameLng-=1
set _filename=!_filename:~1,%_filenameLng%!
aes -e QMIKey "%_pathinput%" "%_foldpath%%_filename%"
if %ERRORLEVEL%==0 del "%_pathinput%"
goto END

:diffEncrypt
aes -d QMIKey "%_pathinput%" "%_pathoutput%"
del "%_pathinput%"
goto END

:: Decryption functions
:decrypt
aes -d QMIKey "%_pathinput%" "%_foldpath%$%_filename%"
if %ERRORLEVEL%==0 del "%_pathinput%"
goto END

:diffDecrypt
aes -d QMIKey "%_pathinput%" "%_pathoutput%"
del "%_pathinput%"
goto END
pause>NUL
:: Reset vars and exit
:END
endlocal
