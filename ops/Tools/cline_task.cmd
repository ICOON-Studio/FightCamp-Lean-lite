@echo off
REM cline_task.cmd - the ONE permitted way Claude launches the Cline CLI on a task.
REM
REM Operator 2026-10-02 (S148): "do these" - Cline joins as a shell agent seat, in its OWN worktree
REM (E:\FightCamp\wt\CLINE, never the main checkout, never system32), on the FREE OpenRouter
REM stealth model (stealth/space-bunny-alpha, expires 2026-10-05) instead of paid Cline credits.
REM
REM Usage:  Tools\cline_task.cmd <prompt-file> <transcript-out-file>
REM
REM The provider key is the OPERATOR's: he runs `cline auth openrouter -k <key> -m stealth/space-bunny-alpha`
REM once. This wrapper never passes a key. Cline auto-approves tools by default and has NO sandbox,
REM so the workspace is pinned to the worktree and the prompt says to stay inside it.
REM CLINE_MODEL / CLINE_REPO / CLINE_TIMEOUT override for one run.

setlocal

if "%~1"=="" (
  echo ERROR: no prompt file given. Usage: cline_task.cmd ^<prompt-file^> ^<out-file^>
  exit /b 2
)
if not exist "%~1" (
  echo ERROR: prompt file not found: %~1
  exit /b 2
)

if defined AGENT_IN_WINDOW goto :run_inline
if not "%AGENT_WINDOW%"=="1" goto :run_inline
set "AGENT_IN_WINDOW=1"
set "DONEF=%TEMP%\agent_done_%~n0_%RANDOM%.txt"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0agent_window.ps1" -Title "CLINE %~n1" -Command "%~f0" -ArgumentString "%~1|%~2" -DoneFile "%DONEF%"
set "RC=%ERRORLEVEL%"
if exist "%DONEF%" del "%DONEF%"
exit /b %RC%
:run_inline

set "CLINE=%APPDATA%\npm\cline.cmd"
if not exist "%CLINE%" (
  echo ERROR: cline CLI not found at %CLINE%  ^(npm install -g cline^)
  exit /b 2
)

set "REPO=E:\FightCamp\wt\CLINE"
if not "%CLINE_REPO%"=="" set "REPO=%CLINE_REPO%"
REM S148: Cline is installed in Claude's shell sandbox, so the operator cannot run `cline auth`. His key lives in
REM %USERPROFILE%\.fightcamp\openrouter_key.txt (written by Tools\cline_set_key.cmd) and is handed over per run with -k.
REM This wrapper never echoes it. CLINE_MODEL overrides the model for one run.
set "KEYFILE=%USERPROFILE%\.fightcamp\openrouter_key.txt"
if not exist "%KEYFILE%" (
  echo ERROR: no OpenRouter key file at %KEYFILE% - the operator runs Tools\cline_set_key.cmd first
  exit /b 2
)
set /p ORKEY=<"%KEYFILE%"
set "MODEL=stealth/space-bunny-alpha"
if not "%CLINE_MODEL%"=="" set "MODEL=%CLINE_MODEL%"
set "MODELFLAG=-P openrouter -k %ORKEY% -m %MODEL%"
set "TIMEOUT=10800"
if not "%CLINE_TIMEOUT%"=="" set "TIMEOUT=%CLINE_TIMEOUT%"
set "OUT=%~2"
if "%OUT%"=="" set "OUT=%TEMP%\cline_last_run.txt"

REM The task text lives in a file (a 6k-char brief needs no quoting); the prompt points at it.
"%CLINE%" -c "%REPO%" %MODELFLAG% --thinking medium -t %TIMEOUT% "Your task is in the file %~f1 . Read it whole, then do it. Work ONLY inside %REPO% - never write outside it. Commit on the current branch when the acceptance test passes." > "%OUT%" 2>&1

endlocal
