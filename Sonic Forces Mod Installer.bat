@echo off
title Sonic Forces Mod Installer v1.5
for %%* in (.) do set foldercheck=%%~nx*
set cpk=wars_patch
set fmiver=1.5

if /I %foldercheck% NEQ SonicForces (
  echo ERROR
  echo.
  echo This bat file/mod folder isn't in the SonicForces folder.
  echo Please put this file/folder in the SonicForces folder and try again.
  pause >nul
  exit
)

if not exist "PackCPK.exe" (
  echo ERROR
  echo.
  echo Could not find PackCPK.exe!
  pause >nul
  exit
)

if not exist "CpkMaker.dll" (
  echo ERROR
  echo.
  echo Could not find CpkMaker.dll!
  pause >nul
  exit
)

if not exist "mods\modsdb.ini" (
  echo. > mods\modsdb.ini
)

md mods
md .\image\x64\disk\mod_installer\
echo Do not delete these folders! These serve as cache for the mod installer! > .\image\x64\disk\mod_installer\readme.txt
cls

:dragdrop
  if "%~1" EQU "" (goto normal)
  for /f "tokens=1,2 delims==" %%a in (%~1\mod.ini) do (
  if /I %%a==title set title=%%b
)

if not exist %~1\mod.ini (
  cls
  echo Not a valid mod folder.
  echo Forgot to create mod.ini?
  pause >nul
  exit
)

  for /f "tokens=1,2 delims==" %%a in (%~1\mod.ini) do (
  if /I %%a==cpk set cpk=%%b
)

  for /f "tokens=1,2 delims==" %%a in (%~1\mod.ini) do (
  if /I %%a==custominstall set custom=%%b
)

  for /f "tokens=1,2 delims==" %%a in (%~1\mod.ini) do (
  if /I %%a==custominstallbat set custombat=%%b
)
  
  for /f "tokens=1,2 delims==" %%a in (%~1\mod.ini) do (
  if /I %%a==author set author=%%b
)


  echo Do you want to install %title% by %author%?
  echo (Installs to %cpk%)
  echo.
  set /p confirm=(Y/N)
  if %confirm% EQU Y goto install
  if %confirm% EQU y goto install
  if %confirm% EQU N goto end
  if %confirm% EQU n goto end
) 

:install
echo --------------------------
if not exist ".\image\x64\disk\%cpk%.cpk.backup" (
  echo No backup detected, backing up %cpk%.cpk as %cpk%.cpk.backup...
  echo f|xcopy /y ".\image\x64\disk\%cpk%.cpk" ".\image\x64\disk\%cpk%.cpk.backup" >nul
) else (
  echo Backup of %cpk%.cpk already detected, proceeding instalation...
  echo You have 7 seconds to close this window if this is wrong...
  echo.
  echo If you already installed mods with this, just press any key
  timeout /t 7 >nul
)
echo --------------------------

if /I %custom% EQU true (
  goto custom
  )

echo --------------------------
echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
  if not exist "image\x64\disk\mod_installer\wars_modinstaller_%cpk%" (
  packcpk ".\image\x64\disk\%cpk%.cpk"
  rename %cpk% wars_modinstaller_%cpk%
  move wars_modinstaller_%cpk% ".\image\x64\disk\mod_installer\" >nul
) else (
  echo Extracted files already found, skipping extraction...
)
echo --------------------------
echo Copying files...
xcopy /s /y "%~1\%cpk%" ".\image\x64\disk\mod_installer\wars_modinstaller_%cpk%" >nul
echo --------------------------
echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
PackCPK ".\image\x64\disk\mod_installer\wars_modinstaller_%cpk%" ".\image\x64\disk\%cpk%"
echo --------------------------
echo %title% >> mods\ModsDB.ini
echo Done! Press any key to exit!
pause >nul
exit

:normal
cls
if not exist "mods" (md mods)
echo Type the mod folder to install that mod
echo Type "delete" to uninstall all currently installed mods
echo Type "refresh" to refresh the mod list
echo Type "check" to check currently installer mods
echo.
echo Mod folders available in the "mods" folder
echo ------------------------------------
dir .\mods /ad /b
echo ------------------------------------
echo.
set /p modfoldernormal=Mod folder: 

if /i %modfoldernormal% EQU delete goto uninstall
if /i %modfoldernormal% EQU refresh goto normal
if /i %modfoldernormal% EQU check goto check

  for /f "tokens=1,2 delims==" %%a in (mods\%modfoldernormal%\mod.ini) do (
  if /I %%a==title set title=%%b
)

  for /f "tokens=1,2 delims==" %%a in (mods\%modfoldernormal%\mod.ini) do (
  if /I %%a==cpk set cpk=%%b
)

  for /f "tokens=1,2 delims==" %%a in (mods\%modfoldernormal%\mod.ini) do (
  if /I %%a==custominstall set custom=%%b
)

  for /f "tokens=1,2 delims==" %%a in (mods\%modfoldernormal%\mod.ini) do (
  if /I %%a==custominstallbat set custombat=%%b
)
  for /f "tokens=1,2 delims==" %%a in (mods\%modfoldernormal%\mod.ini) do (
  if /I %%a==author set author=%%b
)

:confirmnormal

if not exist mods\%modfoldernormal% (
  cls
  echo Mod folder does not exist
  echo Maybe you added a space in the name?
  pause >nul
  goto normal
)

if not exist mods\%modfoldernormal%\mod.ini (
  cls
  echo Not a valid mod folder.
  echo Forgot to create mod.ini?
  pause >nul
  goto normal
)

cls
echo Do you want to install %title% by %author%?
echo (Installs to "%cpk%")
echo.
set /p confirm=(Y/N)
if %confirm% EQU Y goto installnormal
if %confirm% EQU y goto installnormal
if %confirm% EQU N goto normal
if %confirm% EQU n goto normal
goto :confirmnormal

:installnormal
echo --------------------------
if not exist ".\image\x64\disk\%cpk%.cpk.backup" (
  echo No backup detected, backing up %cpk%.cpk as %cpk%.cpk.backup...
  echo f|xcopy /y ".\image\x64\disk\%cpk%.cpk" ".\image\x64\disk\%cpk%.cpk.backup" >nul
) else (
  echo Backup of %cpk%.cpk already detected, proceeding instalation...
  echo You have 7 seconds to close this window if this is wrong...
  echo.
  echo If you already installed mods with this, just press any key
  timeout /t 7 >nul
)
echo --------------------------

if /i %custom% EQU true (
  goto customnormal
  )

echo --------------------------
if not exist "image\x64\disk\mod_installer\wars_modinstaller_%cpk%" (
  echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
  packcpk ".\image\x64\disk\%cpk%.cpk"
  rename %cpk% wars_modinstaller_%cpk%
  move wars_modinstaller_%cpk% ".\image\x64\disk\mod_installer\" >nul
) else (
  echo Extracted files already found, skipping extraction...
)
echo --------------------------
echo Copying files...
xcopy /s /y "mods\%modfoldernormal%\%cpk%" ".\image\x64\disk\mod_installer\wars_modinstaller_%cpk%" >nul
echo --------------------------
echo IF THIS LOOKS STUCK, DON'T DO ANYTHING! IT ISN'T!
PackCPK ".\image\x64\disk\mod_installer\wars_modinstaller_%cpk%" ".\image\x64\disk\%cpk%"
echo --------------------------
echo %title% >> mods\ModsDB.ini
echo Done! Press any key to exit!
pause >nul
exit

:custom
call "%~1\%custombat%"
exit

:customnormal
call "mods\%modfoldernormal%\%custombat%"
exit

:check
cls
echo Currently installed mods:
echo ---------
type mods\ModsDB.ini
echo ---------
echo Press any key to go back to the menu...
pause >nul
goto normal

:uninstall
cls
echo Currently installed mods:
echo ---------
type mods\ModsDB.ini
echo ---------
echo This will uninstall all of your currently installed mods
set /p answer=Proceed (Y/N): 
if /i %answer% equ y goto uninstallyes
goto normal

:uninstallyes
if not exist "image\x64\disk\wars_patch.cpk.backup" (
echo ERROR
echo No backup of wars_patch.cpk detected [wars_patch.cpk.backup]!
echo Without a backup, the uninstaller cannot proceed.
pause >nul
goto normal
)

echo Uninstalling mods...
del image\x64\disk\wars_patch.cpk
ren image\x64\disk\wars_patch.cpk.backup wars_patch.cpk
del /q "image\x64\disk\mod_installer\*"
FOR /D %%p IN ("image\x64\disk\mod_installer\*.*") DO rmdir "%%p" /s /q
echo. > mods\modsdb.ini
echo.
echo Done! Press any key to go back to the menu
pause >nul
goto normal

:end