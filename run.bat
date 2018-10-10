@echo off

IF [%1]==[/?] GOTO :help

echo %* | find "/?" > nul
IF errorlevel 1 GOTO :main

:help

echo.
echo Project OneTimer Load Script
echo ----------------------------
echo Usage: %0 PASS ENV [USER]
echo ------
echo    ENV  -- Workday enviornment to run against [P1, P2, P3, ..].
echo    PASS -- Workday password.
echo    USER -- Workday user (default: wdcnv).

GOTO :end

:main

set TNS_ADMIN=%~dp0\oracle\network\admin
set PATH=%PATH%;%~dp0\oracle\instantclient_12_2
set back=%cd%

set WDPswd=%1
set WDEnv=%2

if "%3"=="" (
  set WDUser=wdcnv
) else (
  set WDUser=%3
)

if "%WDPswd%"=="" set /p WDPswd=What is the password?
if "%WDEnv%"=="" set /p WDEnv=What is the environment [P1, P2, P3]?

for /d %%i in (%~dp0projects\*) do (
 cd %%i
 sqlplus.exe %WDUser%/%WDPswd%@%WDEnv% @%%i\create.sql
 sqlldr userid=%WDUser%/%WDPswd%@%WDEnv% control="%%i\sqlldr.ctl" log="%%i\sqlldr.log" ^
   bad="%%i\sqlldr.bad" discard="%%i\sqlldr.dsc"
)
cd %back%
sqlplus.exe %WDUser%/%WDPswd%@%WDEnv% @projects/export.sql

:end
