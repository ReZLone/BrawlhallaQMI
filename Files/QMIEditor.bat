@echo off
title Brawlhalla Quick-Mod-Installer: QMI Edit Function
cls
cd Files
set param=%~1
echo %param%
pause
if %param%==new (goto newQMI) else (if %param%==edit (goto editQMI) else (echo Wrong parameters))

:editQMI
echo ciao
pause

:newQMI
cd Mods\%foldname%
echo.
echo. If there are more then one author/tag just put a space between them
echo.
echo.
::.qmi file name input
set /p input="Name of the .qmi file: "
set filename=%input: =_%
echo.
::Title input
set /p input2="Enter mod title: "
echo title:%input2%> %filename%.qmi
echo.
::Version input
set /p input3="Enter mod version: "
echo ver:%input3%>> %filename%.qmi
echo.
::Authors input
set /p input4="Enter author(s) name: "
echo author:%input4%>> %filename%.qmi
echo.
::URL input
set /p input5="Enter URL to the download of the mod: "
echo url:%input5%>> %filename%.qmi
echo.
::Source input
set /p input6="Enter the code source of the mod (ex.Github): "
echo source:%input6%>> %filename%.qmi
echo.
::Tags input
set /p input7="Enter the mod tags: "
echo tags:%input7%>> %filename%.qmi
::CD back to \Files\
cd %homepath%
goto END

pause > NUL
:END