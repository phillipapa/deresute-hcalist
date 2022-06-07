:main
@echo off &cls
color 07
echo       ==========================================================================
echo                             HCALIST HELPER VERSION 07062022
echo                       Companion tool for deresute song extraction
echo                                     Copyleft 2022
echo       ==========================================================================
echo       DISCLAIMER: This script is provided as is, in hope that it will be useful.
echo                   The author is not responsible for any kinds of damages on your
echo                   system(s). By continuing, you agree to these terms.
echo       ==========================================================================
echo.
echo How to use: 
echo 1. Extract (if archived) or put this bat file in a place containing folder/subfolder
echo    "deresute_hca" which contains all of your hca files (NOT acb)
echo 2. Create or fill in "hcadb.txt" by copying from manifest db on "name" column (block
echo    all from top to bottom) and copying it to the txt file
echo    (use db browser to open manifest, type on the "name" filter "l/" without quotes)
echo 3. "hcalist.txt" is automatically filled
echo 4. Compared difference at "hcadiff.txt"
echo 5. Any hca files that are non standard (like having an underscore after song
echo    number) will be excluded by default. You can edit the default exclusions at
echo    the variable "default_exclusions" by editing this script
echo 6. Might require admin permissions if used in C:\ directory. Not recommended though,
echo    as to prevent unintended stuff from happening
echo.

SETLOCAL ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
net session >nul 2>&1
if %errorLevel% == 0 (
    echo RUNNING IN ADMIN MODE, be careful^^!
) else (
    echo RUNNING IN USER MODE, make sure to place any of the required files outside of C: directory.
)
echo.
pause
echo.

REM You can change the default excluded files here.
REM By default, it is: part _se _movie _call _collab .awb

SET "default_exclusions="

SET "choice=n" && SET "maxtime=1000" && SET "mintime=500"
SET "find1=acb" && SET "repl1=hca" && SET "find2=l/" && SET "repl2="
SET "hca_dir=%~dp0deresute_hca\" && SET "hcadb_txt_filedir=%~dp0hcadb.txt"
echo Working...
call :progstart
call :prog1
IF NOT EXIST %hcadb_txt_filedir% (call :emptynotfound %hcadb_txt_filedir% & goto :done)
for %%S in (%hcadb_txt_filedir%) do IF %%~zS lss 1 (call :emptynotfound %hcadb_txt_filedir% & goto :done)
IF NOT EXIST %hca_dir% (call :emptynotfound %hca_dir% & goto :done)
cd %~dp0deresute_hca
call :prog2
IF EXIST "%~dp0hcadiff.txt" (type nul>%~dp0hcadiff.txt)
dir /b >..\hcalist.txt
call :prog3

for /f "delims=" %%a in (%~dp0hcadb.txt) do (
    SET s=%%a
    SET s=!s:%find1%=%repl1%!
    SET s=!s:%find2%=%repl2%!
    echo !s! >> %~dp0hcatemp.txt
)
call :prog4

for /f "delims=" %%b in (%~dp0hcalist.txt) do (
    SET t=%%b
    echo !t! >> %~dp0hcatemp2.txt
)
call :prog5

findstr /vixg:%~dp0hcatemp2.txt %~dp0hcatemp.txt > %~dp0hcadiff.txt
call :prog6
type nul> %~dp0hcatemp.txt
call :prog7
call :resetexclusions "part _se _movie _call _collab .awb"
findstr /vi "%default_exclusions%" %~dp0hcadiff.txt > %~dp0hcatemp.txt
call :prog8
del /f %~dp0hcatemp2.txt && del /f %~dp0hcadiff.txt && del /f %~dp0hcalist.txt
call :prog9
rename %~dp0hcatemp.txt hcadiff.txt
call :prog10
set "cmd=findstr /R /N "^^" %~dp0hcadiff.txt | find /C ":""
for /f %%c in ('!cmd!') do set number=%%c
call :prog11
if [%number%] leq [0] goto :nonew
if [%number%] gtr [0] goto :found
ENDLOCAL

:found
echo.
echo.
echo Found file(s):
echo.
type %~dp0hcadiff.txt
echo.
echo Total: %number% new file(s) to be added.
echo Using exclusions: %default_exclusions%
echo.
echo Done.
echo.
goto :done

:nonew
echo.
echo.
echo No new file(s) found
echo Using exclusions: %default_exclusions%
echo.
echo Done.
echo.
goto :done

:done
set /p "choice=Continue scanning (type Y to continue, anything else to quit)? "
if /i "%choice%" equ "y" goto :main
if /i "%choice%" neq "y" goto :eof
goto :done

:emptynotfound [dirorfile]
call :progerror
echo.
echo.
echo ERROR: %1: File or directory not found. Please check if the file or directory is there.
echo In case of hcadb.txt file, check if it's not empty.
echo.
goto :eof 

:resetexclusions [defaultexclusions]
IF NOT DEFINED default_exclusions (SET "default_exclusions=%~1")
IF "%default_exclusions: =%"=="" (SET "default_exclusions=%~1")
goto :eof

:waiter [mintime] [maxtime]
SET /a "loadt=%RANDOM% * (%~2 - %~1 + 1) / 32768 + %~1"
PING 192.0.2.1 -n 1 -w %loadt% > nul
goto :eof

:progstart
for /l %%f in (0 1 0) do (
	call :drawProgressBar %%f "Preparing..."
)
call :waiter %mintime% %maxtime%
goto :eof

:prog1
for /l %%f in (1 1 3) do (
	call :drawProgressBar %%f "Setting up..."
)
call :waiter %mintime% %maxtime%
goto :eof

:prog2
for /l %%f in (4 1 7) do (
	call :drawProgressBar %%f "Looking for files..."
)
call :waiter %mintime% %maxtime%
goto :eof

:prog3
for /l %%f in (8 1 10) do (
	call :drawProgressBar %%f "Detecting changes..."
)
goto :eof

:prog4
for /l %%f in (11 1 40) do (
    call :drawProgressBar %%f "Detecting changes..."
)
goto :eof

:prog5
for /l %%f in (41 1 65) do (
    call :drawProgressBar %%f "Detecting changes..."
)
goto :eof

:prog6
for /l %%f in (66 1 70) do (
    call :drawProgressBar %%f "Replacing files..."
)
goto :eof

:prog7
for /l %%f in (71 1 75) do (
    call :drawProgressBar %%f "Replacing files..."
)
goto :eof

:prog8
for /l %%f in (76 1 80) do (
    call :drawProgressBar %%f "Replacing files..."
)
goto :eof

:prog9
for /l %%f in (81 1 85) do (
    call :drawProgressBar %%f "Replacing files..."
)
goto :eof

:prog10
for /l %%f in (86 1 90) do (
    call :drawProgressBar %%f "Preparing file listing..."
)
call :waiter %mintime% %maxtime%
goto :eof

:prog11
for /l %%f in (91 1 100) do (
    call :drawProgressBar %%f "Completed."
)
call :waiter %mintime% %maxtime%
goto :eof

:progerror
for /l %%f in (0 100 100) do (
    call :drawProgressBar %%f "Errored."
)
goto :eof

:drawProgressBar value [text]
if "%~1"=="" goto :eof
if not defined pb.barArea call :initProgressBar
setlocal enableextensions enabledelayedexpansion
set /a "pb.value=%~1 %% 101", "pb.filled=pb.value*pb.barArea/100", "pb.dotted=pb.barArea-pb.filled", "pb.pct=1000+pb.value"
set "pb.pct=%pb.pct:~-3%"
if "%~2"=="" ( set "pb.text=" ) else ( 
    set "pb.text=%~2%pb.back%" 
    set "pb.text=!pb.text:~0,%pb.textArea%!"
)
<nul set /p "pb.prompt= !pb.fill:~0,%pb.filled%!!pb.dots:~0,%pb.dotted%! [%pb.pct%%%] %pb.text%!pb.cr!"
endlocal
goto :eof

:initProgressBar [fillChar] [dotChar]
chcp 65001 >nul
if defined pb.cr call :finalizeProgressBar
for /f %%a in ('copy "%~f0" nul /z') do set "pb.cr=%%a"
if "%~1"=="" ( set "pb.fillChar=▓" ) else ( set "pb.fillChar=%~1" )
if "%~2"=="" ( set "pb.dotChar=▒" ) else ( set "pb.dotChar=%~2" )
set "pb.console.columns="
for /f "tokens=2 skip=4" %%f in ('mode con') do if not defined pb.console.columns set "pb.console.columns=%%f"
set /a "pb.barArea=pb.console.columns/2-2", "pb.textArea=pb.barArea-9"
set "pb.fill="
setlocal enableextensions enabledelayedexpansion
for /l %%p in (1 1 %pb.barArea%) do set "pb.fill=!pb.fill!%pb.fillChar%"
set "pb.fill=!pb.fill:~0,%pb.barArea%!"
set "pb.dots=!pb.fill:%pb.fillChar%=%pb.dotChar%!"
set "pb.back=!pb.fill:~0,%pb.textArea%!
set "pb.back=!pb.back:%pb.fillChar%= !"
endlocal & set "pb.fill=%pb.fill%" & set "pb.dots=%pb.dots%" & set "pb.back=%pb.back%"
chcp 1252 >nul
goto :eof

:finalizeProgressBar [erase]
if defined pb.cr (
    if not "%~1"=="" (
        setlocal enabledelayedexpansion
        set "pb.back="
        for /l %%p in (1 1 %pb.console.columns%) do set "pb.back=!pb.back! "
        <nul set /p "pb.prompt=!pb.cr!!pb.back:~1!!pb.cr!"
        endlocal
    )
)
for /f "tokens=1 delims==" %%v in ('set pb.') do set "%%v="
goto :eof
