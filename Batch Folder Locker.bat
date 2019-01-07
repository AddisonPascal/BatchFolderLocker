@echo off
rem Batch Folder Locker by Addison Djatschenko (v0.1)
title Batch Folder Locker
mode 1000
set isOpeningFolder=.%1
if %isOpeningFolder%==. (
set isOpeningFolder=false
goto home
)
set isOpeningFolder=true
set openingFolderPath=%1
if "%openingFolderPath:~-5,5%==".blf" goto openingFolder
if "%openingFolderPath:~-5,5%==".BLF" goto openingFolder
set folderToLock=%openingFolderPath:~0,-1%
cls
set /p folderNameLocked="Folder Name: "
goto lock

:home
cls
echo Will only lock folders with files in it, not folders inside folders.
echo Folder to lock (in this folder):
set /p folderNameLocked="--> "
if not exist "%~dp0%folderNameLocked%" goto home
set folderToLock="%~dp0%folderNameLocked%
:lock
echo Password:
set /p passwordToLock="--> "
md "%appdata%\BFL"
set folderID=%random%%random%%random%
md "%appdata%\BFL\%folderID%"
md "%appdata%\BFL\%folderID%\%folderNameLocked%"
copy %folderToLock%\*" "%appdata%\BFL\%folderID%\%folderNameLocked%"
(
@echo off
echo set password=%passwordToLock%
)>"%appdata%\BFL\%folderID%\data.bat"
attrib +h +s "%appdata%\BFL\%folderID%\%folderNameLocked%"
attrib +h +s "%appdata%\BFL\%folderID%\data.bat"
attrib +h +s "%appdata%\BFL\%folderID%"
(
@echo off
echo set folderID=%folderID%
echo set folderName=%folderNameLocked%
)>"%~dp0\%folderNameLocked%-Locked.blf"
cls
echo Locked folder!
echo Press any key to exit...
pause>nul
exit

:openingFolder
del "%appdata%\BFL\tmp.bat"
copy %openingFolderPath% "%appdata%\BFL\tmp.bat"
call "%appdata%\BFL\tmp.bat"
del "%appdata%\BFL\tmp.bat"
call "%appdata%\BFL\%folderID%\data.bat"
title Opening Folder %folderName%
cls
echo Opening Folder %folderName%. 
echo Password: 
set /p passwordAttempt= "--> "
if "%passwordAttempt%"=="%password%" goto unlock
goto openingFolder

:unlock
cls
echo Unlocked. Opening folder...
explorer "%appdata%\BFL\%folderID%\%folderName%"
pause
exit