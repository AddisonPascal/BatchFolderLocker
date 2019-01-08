@echo off
rem Batch Folder Locker by Addison Djatschenko (v0.3)
title Batch Folder Locker
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
echo Password (Numbers and letters only!!):
set /p passwordToLock="--> "
md "%appdata%\BFL"
set folderID=%random%%random%%random%
md "%appdata%\BFL\%folderID%%passwordToLock%"
md "%appdata%\BFL\%folderID%%passwordToLock%\%folderNameLocked%"
copy %folderToLock%\*" "%appdata%\BFL\%folderID%%passwordToLock%\%folderNameLocked%"
attrib +h +s "%appdata%\BFL\%folderID%%passwordToLock%\%folderNameLocked%"
attrib +h +s "%appdata%\BFL\%folderID%%passwordToLock%\data.bat"
attrib +h +s "%appdata%\BFL\%folderID%%passwordToLock%"
md "C:\Users\%username%\Desktop\Batch Locked Folders"
(
@echo off
echo set folderID=%folderID%
echo set folderName=%folderNameLocked%
)>"C:\Users\%username%\Desktop\Batch Locked Folders\%folderNameLocked%-Locked.blf"
echo C:\Users\%username%\Desktop\Batch Locked Folders\%folderNameLocked%-Locked.blf |clip
cls
echo Locked folder! Saved to Desktop\Batch Locked Folders.
echo Link to locked folder saved to clipboard.
echo Press any key to exit...
pause>nul
exit

:openingFolder
del "%appdata%\BFL\tmp.bat"
copy %openingFolderPath% "%appdata%\BFL\tmp.bat"
call "%appdata%\BFL\tmp.bat"
del "%appdata%\BFL\tmp.bat"
if not exist "%appdata%\BFL\%folderID%" goto notexist
title Opening Folder %folderName%
cls
echo Opening Folder %folderName%. 
echo Password: 
set /p passwordAttempt= "--> "
if exist "%appdata%\BFL\%folderID%%passwordToLock%" goto unlock
goto openingFolder

:notexist
cls
echo Locked Folder Not Available!
echo Either an error has occured, or the Locked Folder was created on another computer. 
echo You cannot open Locked Folders on other computers.
pause>nul
exit

:unlock
cls
echo Unlocked. Opening folder...
explorer "%appdata%\BFL\%folderID%%passwordToLock%\%folderName%"
pause
exit