@echo off
mode 100,20
title Brawlhalla Quick-Mod-Installer
set "Path=%Path%;%cd%;%cd%\Files"
setlocal EnableDelayedExpansion
::attrib +h QMIEditFunction.bat
set batpath=%CD%
cd Files
echo -%date%-%time%--SYSTEM- Program initialised by the user >> log.txt
set filespath=%CD%

:: Check if temp files were left in the last execution
if exist qmils.tmp del qmils.tmp
if exist uncryptedls.tmp del uncryptedls.tmp

::Check if qmi files were left uncrypted
dir /b /s *.qmi|find "$" > uncryptedls.tmp
for /F "tokens=* usebackq" %%F in (`list "uncryptedls.tmp" /ll`) do (
set uncryptednum=%%F
)
set /a nowEncr=0
:encryptLeftQMILoop
call progress 80 %nowEncr% %uncryptednum%
echo.
echo %nowEncr%/%uncryptednum%
for /F "tokens=* usebackq" %%F in (`list "uncryptedls.tmp" /ra 0`) do (
set _filetoencrypt=%%F
)
QMIEncryptor -e "%_filetoencrypt%"
set /a nowEncr+=1
if %nowEncr% lss %uncryptednum% goto encryptLeftQMILoop
pause

:: Check if log is occuping too much space and if it is deletes it
FOR /F "usebackq" %%A IN ('log.txt') DO set size=%%~zA
if %size% gtr 5000 del log.txt

:: Check if a file was Drag and Dropped
if "%~1"=="" echo -%date%-%time%--SYSTEM- No Drag and Drop function detected >> log.txt & goto scanQMIs
echo -%date%-%time%--SYSTEM- Drag and Drop File detected >> log.txt
goto installZipRequest

:installZipRequest
cls
echo.
set zippath=%~1
:: Clear the path
for %%I in (%zippath%) do set tempname1=%%~I
:pathClearerLoopZip
set tempname2=%tempname1:*\=%
if not %tempname1% == %tempname2% ( set tempname1=%tempname2% & goto pathClearerLoopZip )
set zipname=%tempname1%
:: Check if it is a supported file
if %zipname%==%zipname:.zip=% echo. & echo [91m This file is not supported for now (only working with .zip) & echo. & pause>NUL|echo. Press any key to continue[0m & goto scanQMIs
:: Check if file name contains spaces
if not %zipname: =%==%zipname% echo. & echo [91m This file is not supported for now (only working with non-spaced names) & echo. & pause>NUL|echo. Press any key to continue[0m & goto scanQMIs
:: Set the fold name from the archive
set foldname=%zipname:.zip=%
set foldname=%foldname: =%

:requestInstall
echo -%date%-%time%--SYSTEM- Install mod folder request: Pending... >> log.txt
echo  Do you want to extract the zip file and install the mod folder?
echo.
cmdMenuSel 0FF0 " YES" " NO"
if %ERRORLEVEL%==1 echo -%date%-%time%--SYSTEM- Install mod folder file request: Accepted >> log.txt & goto unzipInstall
if %ERRORLEVEL%==2 echo -%date%-%time%--SYSTEM- Install mod folder file request: Declined >> log.txt & goto checkPath

:unzipInstall
cd Mods
if not exist %foldname% mkdir %foldname%
cd %foldname%
tar -xf "%zippath%"
cd %filespath%
goto deleteZip

:deleteZip
cls
echo.
echo. Do you want to delete the .zip file?
echo.
cmdMenuSel 0FF0 " YES" " NO"
if %ERRORLEVEL%==1 goto confirmDelZip
if %ERRORLEVEL%==2 goto qmiInZip

:confirmDelZip
echo.
echo Are you sure?
echo.
cmdMenuSel 0FF0 " YES" " NO"
if %ERRORLEVEL%==1 del "%zippath%" & goto qmiInZip
if %ERRORLEVEL%==2 goto deleteZip

:qmiInZip
cls
cd Mods\%foldname%
echo.
echo. [92mMod folder installed in %CD%[0m
echo.
pause > NUL|echo. Press any key to continue
if exist *.qmi echo. & echo [1;92m Found QuickModInfo File (.qmi)[0m & echo. & pause > NUL | echo  Press any key to continue & goto scanQMIs
goto noQMI

:noQMI
cls
echo.
echo [91;1m No QuickModInfo File (.qmi) Found inside %zipname%[0m
echo.
echo. Do you want to create one now? [91;1m(WARNING: not creating one will prevent the program from detecting the mod)[0m
echo.
cmdMenuSel 0FF0 " YES" " NO"
if %ERRORLEVEL%==1 goto createQMI
if %ERRORLEVEL%==2 goto scanQMIs

:createQMI
QMIEditFunction new
title Brawlhalla Quick-Mod-Installer
echo.
pause > NUl|echo. Press any key to continue
goto scanQMIs


:scanQMIs
cd %filespath%
cls
title Brawlhalla Quick-Mod-Installer: Scan for QMIs?
dir /b /s *.qmi> qmils.tmp
for /F "tokens=* usebackq" %%F in (`list "qmils.tmp" /ll`) do (
set modscount=%%F
)
echo.

::echo end>> mods.tmp
::dir /b *.qmi /s 2> nul | find "" /v /c > %temp%\count
::set /p modscount=< %temp%\count
::del %temp%\count
set /a i=1
::set n1=1
::set n2=2
:::loadModLoop
::< mods%n1%.ini (
::	set /p qmipath[%i%]=
::	)
::
pause>NUL|echo  Press any key to start scanning the mods folder 
title Brawlhalla Quick-Mod-Installer: Scanning QMIs...
echo.
:qmiPathsLoop
for /F "tokens=* usebackq" %%F in (`list "qmils.tmp" /gi 0`) do (
set qmipath[%i%]=%%F
)
for %%E in (!qmipath[%i%]!) do set tempname1=%%~E

:pathClearerLoopQMI
set tempname2=%tempname1:*\=%
if not %tempname1% == %tempname2% ( set tempname1=%tempname2% & goto pathClearerLoopQMI )
set qminame[%i%]=%tempname1: =%
echo. [92;4;3mFound QMI[0;3m : !qmipath[%i%]![0m
set _qminame=!qminame[%i%]!
set _qmipath=!qmipath[%i%]!

echo %_qminame%> tempfile.tmp
for %%? in (tempfile.tmp) do ( set /A qminameleng=%%~z? - 2 )
del tempfile.tmp

set modfold[%i%]=!_qmipath:~0,-%qminameleng%!
set _modfold=!modfold[%i%]!

list "qmils.tmp" /ra 0 > NUL
::more +1 mods%n1%.ini > mods%n2%.ini
::if %n1%==1 ( set /a n1=2 & set /a n2=1 ) else ( set /a n1=1 & set /a n2=2 )
set /a i+=1
timeout /t 1 /NOBREAK > NUL
if not %i% gtr %modscount% goto qmiPathsLoop
::Cleaning up temp files
::del mods1.ini & del mods2.ini
del qmils.tmp
title Brawlhalla Quick-Mod-Installer: Scanning QMIs [Finished]
echo.
echo  QMI(s) detected : [92;3m%modscount%[0m
echo.
title Brawlhalla Quick-Mod-Installer
set allgood=true
set /a i=1
pause > NUL | echo. Press any key to continue
cls
title Brawlhalla Quick-Mod-Installer: Loading QMIs...
:qmiLoadLoop
set /a p= %i% - 1
::call Progress 80 %p% %modscount%
set _qminame=!qminame[%i%]!
set _modfold=!modfold[%i%]!
pause
for /F "tokens=* usebackq" %%F in (`list "Mods/%_modfold%/%_qminame%.qmi" /ll`) do (
set _qmileng=%%F
)
if not _qmileng==8 set validQmi[%i%]=false
::< %_qminame%.qmi (
::	set /p titlemod[%i%]=
::	set /p gamevermod[%i%]=
::	set /p vermod[%i%]=
::	set /p authormod[%i%]=
::	set /p urlmod[%i%]=
::	set /p sourcemod[%i%]=
::	set /p tagsmod[%i%]=
::	set /p statusmod[%i%]=
::	)
::echo !titlemod[%i%]! !gamevermod[%i%]! !vermod[%i%]! !authormod[%i%]! !urlmod[%i%]! !sourcemod[%i%]! !tagsmod[%i%]! !statusmod[%i%]!
::if !titlemod[%i%]:title:=%!==!titlemod[%i%]! set allgood=false & set loadedmod[%i%]=false & goto changeLoad
::if !gamevermod[%i%]:game.ver:=%!==!gamevermod[%i%]! set allgood=false & set loadedmod[%i%]=false & goto changeLoad
::if !vermod[%i%]:ver:=%!==!vermod[%i%]! set allgood=false & set loadedmod[%i%]=false & goto changeLoad
::if !authormod[%i%]:author:=%!==!authormod[%i%]! set allgood=false & set loadedmod[%i%]=false & goto changeLoad
::if !statusmod[%i%]:status:=%!==!statusmod[%i%]! set allgood=false & set loadedmod[%i%]=false & goto changeLoad
::set loadedmod[%i%]=true
:changeLoad
set /a i+=1
if not %i% gtr %modscount% goto qmiLoadLoop

set /a i=0
:qmiNameDisplay
if !loadedmod[%i%]!==true (echo. [92m!qminame[%i%]![0m) else (echo. [91m!qminame[%i%]![0m)
set /a i+=1
if not %i% gtr %f% goto qmiNameDisplay
echo.
pause > NUL | echo  Press any key to continue
goto checkPath


:checkPath
cd %filespath%
cls
echo -%date%-%time%--SYSTEM- Checking path... >> log.txt
if exist path.ini (echo -%date%-%time%--SYSTEM- Game-path found in "path.ini" >> log.txt & goto loadPath) else (echo -%date%-%time%--SYSTEM- No game-path found in "path.ini" >> log.txt & goto noPath)


:noPath
cls
echo -%date%-%time%--SYSTEM- Default game-path request: Pending... >> log.txt
echo. 
echo [91mIt seems you haven't assigned the path to the Brawlhalla folder.[0m
echo This means that the default path will be used. (C:\Program Files\Steam\steamapps\common\Brawhalla)
echo.
echo. Do you want to change it?
echo.
cmdMenuSel 0FF0 " YES" " NO"
if %ERRORLEVEL%==1 echo -%date%-%time%--SYSTEM- Default game-path request: Declined >> log.txt & goto inputGamePath
if %ERRORLEVEL%==2 echo -%date%-%time%--SYSTEM- Default game-path request: Accepted >> log.txt & set gamepath=C:\Program Files\Steam\steamapps\common\Brawhalla & goto saveGamePath

:saveGamePath
echo %gamepath% > path.ini
echo -%date%-%time%--SYSTEM- Saved the default game path in "path.ini" >> log.txt
goto inputManagerPath

:inputGamePath
cls
echo.
echo Insert the path here:
set /p gamepath=
set drive=%gamepath:~0,1%
echo %drive%> path.ini
echo %gamepath%>> path.ini
echo -%date%-%time%--SYSTEM- Saved the custom game path in "path.ini" >> log.txt
goto mainMenu

:loadPath
< path.ini (
	set /p drive=
	set /p gamepath=
	)
echo -%date%-%time%--SYSTEM- Loaded the path from "path.ini" >> log.txt
goto mainMenu

:mainMenu
cls
echo.
echo What do you want to do?
echo.
echo -%date%-%time%--SYSTEM- Main-Menu input: Pending... >> log.txt
cmdMenuSel 0FF0 " MOD LIST" " EDIT QMIs" " EXIT"
if %ERRORLEVEL%==1 echo -%date%-%time%--SYSTEM- Main-Menu input: Mod List >> log.txt & goto modList
if %ERRORLEVEL%==2 echo -%date%-%time%--SYSTEM- Main-Menu input: Edit QMIs >> log.txt & goto editQMIs
if %ERRORLEVEL%==3 echo -%date%-%time%--SYSTEM- Main-Menu input: Exiting program... >> log.txt & exit

:modList

:editQMIs
echo %i%
pause

:END
endlocal
pause > NUL
