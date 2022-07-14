@echo off
title Brawlhalla Quick-Mod-Installer: QMI Edit Function
cls
cd %filespath%/Mods/%foldname%
set param=%~1
if %param%==new (goto _newQMI) else (if %param%==edit (goto _editQMI) else (echo Wrong parameters))

:_editQMI
echo ciao
pause

:_newQMI
echo.
echo. If there are more then one author/tag just put a space between them (*=obbligatory)
echo.
echo.
::.qmi file name input
:_inputName
set /p input1="*Name of the .qmi file: "
if "%input1%"=="" echo. & echo [91;3m You have to fill this field to continue[0m & echo. & goto _inputName
set filename=%input1: =_%
echo.
::Creating the list .qmi
list "$%filename%.qmi" /nl

::Mod title input
:_inputTitle
set /p input2="*Enter mod title: "
if "%input2%"=="" echo. & echo [91;3m You have to fill this field to continue[0m & echo. & goto _inputTitle
echo.
::Game version input
:_inputGameVer
set /p input3="*Enter the game version compatible with this mod: "
if "%input3%"=="" echo. & echo [91;3m You have to fill this field to continue[0m & echo. & goto _inputGameVer
echo.
::Mod version input
:_inputModVer
set /p input4="*Enter version of the mod file: "
if "%input4%"=="" echo. & echo [91;3m You have to fill this field to continue[0m & echo. & goto _inputModVer
echo.
::Authors input
:_inputAuthors
set /p input5="*Enter author(s) name: "
if "%input5%"=="" echo. & echo [91;3m You have to fill this field to continue[0m & echo. & goto _inputAuthors
echo.
::URL input
set /p input6="Enter URL to the download of the mod: "
echo.
::Source input
set /p input7="Enter URL to the source-code of the mod (ex.Github): "
echo.
::Tags input
set /p input8="Enter the mod tags: "
::set mod status
::Add inputs and status to list
list "$%filename%.qmi" /ps "status:NotActive" "tags:%input8%" "source:%input7%" "url:%input6%" "author:%input5%" "ver:%input4%" "game.ver:%input3%" "title:%input2%" 0
QMIEncryptor -e "$%filename%.qmi" "%filename.qmi%"
cd %filespath%
goto END

pause > NUL
:END