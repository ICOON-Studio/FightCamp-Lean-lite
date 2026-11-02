@echo off
REM agent_window.cmd - thin forwarder to agent_window.ps1, which is the real
REM tool. Kept so an agent window can be opened from cmd as well as PowerShell.
REM
REM Usage:  Tools\agent_window.cmd <window-title> <command> [args...]
REM
REM THIS USED TO USE cmd's OWN `start` AND THAT DOES NOT WORK FROM CLAUDE'S
REM SHELL. Claude runs in a HIDDEN console and `start` inherits the hidden
REM window state: the agent runs correctly and its window never appears. It was
REM measured rather than guessed - a window enumeration found ZERO visible agent
REM windows after a `start` launch and exactly one after Start-Process, which
REM sets the window state explicitly through STARTUPINFO instead of inheriting
REM it. See the header of agent_window.ps1. Do not put `start` back.

setlocal

if "%~1"=="" (
  echo ERROR: no title given. Usage: agent_window.cmd ^<title^> ^<command^> [args...]
  exit /b 2
)
if "%~2"=="" (
  echo ERROR: no command given. Usage: agent_window.cmd ^<title^> ^<command^> [args...]
  exit /b 2
)

set "HERE=%~dp0"
REM S76: capture title and command BEFORE the loop - `shift` moves %1/%2 too, so
REM reading "%~2" after it passed the LAST argument as the command.
set "TITLE=%~1"
set "COMMAND=%~2"

REM Arguments 3..N become the -Arguments array. Each is quoted on the way
REM through because the repo and temp paths both contain spaces.
set "ARGS="
:collect
if "%~3"=="" goto run
if defined ARGS (set "ARGS=%ARGS%,'%~3'") else (set "ARGS='%~3'")
shift
goto collect

:run
if defined ARGS (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%HERE%agent_window.ps1" -Title "%TITLE%" -Command "%COMMAND%" -Arguments %ARGS%
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%HERE%agent_window.ps1" -Title "%TITLE%" -Command "%COMMAND%"
)

endlocal
