@echo off
REM cursor_task.cmd - the ONE permitted way Claude launches Cursor on a task.
REM
REM Usage:  Tools\cursor_task.cmd <prompt-file> <workspace-dir> [out-file]
REM
REM WHY THIS WRAPPER EXISTS (2026-09-20). cursor-agent implements Claude Code
REM hook compatibility: it reads %USERPROFILE%\.claude\settings.json and runs
REM whatever PreToolUse hooks it finds there. On Windows it builds the hook
REM invocation as POWERSHELL -
REM
REM   $OutputEncoding = [System.Text.Encoding]::UTF8; Get-Content -LiteralPath
REM   '<payload>.json' -Raw ^| ^& { $input ^| rtk hook claude }
REM
REM - and then evaluates that string with BASH, which dies on `&` and
REM `$OutputEncoding`. EVERY shell command inside cursor-agent is then rejected
REM before it runs, `echo test` included:
REM
REM   Rejected: Hook blocked with message: --: eval: line 1: syntax error near
REM   unexpected token `&'
REM
REM That is a cursor-agent bug on Windows and it has nothing to do with RTK:
REM the broken `&` and `$OutputEncoding` are Cursor's own wrapper, so ANY
REM Claude Code hook breaks it. On 2026-09-20 it cost Cursor the whole of
REM U109 - it wrote both tools correctly and could not run one line, no gate,
REM no commit, no push.
REM
REM WHAT DID NOT WORK, so nobody re-tries them: CLAUDE_CONFIG_DIR pointed at an
REM empty directory (cursor-agent ignores it), and an empty .cursor\hooks.json
REM in the project or in the user directory (Cursor's own hook file does not
REM override the Claude import).
REM
REM WHAT WORKS: give cursor-agent a HOME where there are no Claude hooks to
REM find. The shim holds an empty .claude\settings.json and a JUNCTION to the
REM real %USERPROFILE%\.cursor, so Cursor's auth, config and chat history are
REM all still its own - only the Claude settings are hidden.
REM
REM THE USER'S OWN `rtk hook claude` IS LEFT COMPLETELY ALONE. It works
REM correctly in Claude Code and it saves tokens on every Bash call; this
REM wrapper hides it from Cursor rather than removing it from Claude.

setlocal

if "%~1"=="" (
  echo ERROR: no prompt file given. Usage: cursor_task.cmd ^<prompt-file^> ^<workspace-dir^> [out-file]
  exit /b 2
)
if not exist "%~1" (
  echo ERROR: prompt file not found: %~1
  exit /b 2
)
if "%~2"=="" (
  echo ERROR: no workspace given. Usage: cursor_task.cmd ^<prompt-file^> ^<workspace-dir^> [out-file]
  exit /b 2
)
if not exist "%~2" (
  echo ERROR: workspace not found: %~2
  exit /b 2
)


REM ============================================================= VISIBLE WINDOW
REM OPERATOR REQUEST 2026-09-20, RESTATED 2026-09-22: "i want to be able to see
REM the agents clis when they work" / "open that on the side i can see
REM inputs/outputs live ... for every session start".
REM
REM agent_window.ps1 existed from the FIRST request and was routed around for
REM two days, because it was a rule a session had to remember rather than a
REM gate. So the gate lives HERE: the launcher re-runs ITSELF inside a visible
REM console and waits on a sentinel file. AGENT_IN_WINDOW stops the recursion.
REM AGENT_NO_WINDOW=1 is the deliberate opt-out, for a measurement that must
REM not spawn windows.
REM
REM The window uses `cmd /k` and STAYS OPEN when the run ends, so the operator
REM can read the whole transcript afterwards. That is why the wait is on the
REM sentinel and not on the process - see agent_window.ps1.
if defined AGENT_IN_WINDOW goto :run_inline
REM OPERATOR, 2026-09-22: "stopmaking those cli shells poping up". The window
REM is now OPT-IN. It was default-on for a few hours after the earlier request
REM to see the agents work; seeing them pop up in practice settled it. The gate
REM stays wired and proven so AGENT_WINDOW=1 turns it back on for one launch.
if not "%AGENT_WINDOW%"=="1" goto :run_inline
set "AGENT_IN_WINDOW=1"
set "DONEF=%TEMP%\agent_done_%~n0_%RANDOM%.txt"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0agent_window.ps1" -Title "CURSOR %~n1" -Command "%~f0" -ArgumentString "%~1|%~2|%~3" -DoneFile "%DONEF%"
set "RC=%ERRORLEVEL%"
if exist "%DONEF%" del "%DONEF%"
exit /b %RC%
:run_inline

set "SHIM=%LOCALAPPDATA%\Temp\fightcamp-cursor-home"
if not exist "%SHIM%\.claude" mkdir "%SHIM%\.claude"
if not exist "%SHIM%\.claude\settings.json" echo {}> "%SHIM%\.claude\settings.json"
if not exist "%SHIM%\.cursor" mklink /J "%SHIM%\.cursor" "%USERPROFILE%\.cursor" >nul

REM The model and flags are the operator's fixed settings for Cursor and are
REM pinned here so no launch inherits something else.
REM S131: CURSOR_MODEL overrides the model for ONE launch when the operator picks
REM one (2026-09-30, U199 lobby art: "Sonnet 5" - a model that can see renders).
if "%CURSOR_MODEL%"=="" set "CURSOR_MODEL=composer-2.5"
REM S214: note the model this launch runs, for the model-router live view (127.0.0.1:4101).
for %%I in ("%~2") do set "FC_WT=%%~nxI"
if not exist "C:\Users\user\.claude\mods\model-router-live\agents" mkdir "C:\Users\user\.claude\mods\model-router-live\agents"
(echo %CURSOR_MODEL%)> "C:\Users\user\.claude\mods\model-router-live\agents\%FC_WT%.txt"
set "OUT=%~3"
if "%OUT%"=="" set "OUT=%TEMP%\cursor_task_last.txt"

set "USERPROFILE=%SHIM%"
set "HOME=%SHIM%"

REM LIVE MODE (operator, 2026-09-20: "i asked to be able to see their cli in
REM your app"). FIGHTCAMP_AGENT_STREAM=1 runs the agent with NO redirect at all,
REM so its stdout goes straight to whoever launched it - which is what puts it
REM live in the Claude app's tasks pane.
REM
REM IT USED TO PIPE THROUGH PowerShell Tee-Object AND THAT WAS THE BUG. Tee-Object
REM BUFFERS: Codex, which prints straight to stdout, streamed 36 KB into the pane
REM while Qwen behind the tee sat at 272 bytes - one warning line - and looked
REM dead. Do not reintroduce a pipe here to get a copy of the log; the launcher's
REM own capture IS the log.
if "%FIGHTCAMP_AGENT_STREAM%"=="1" (
  cursor-agent.cmd -p --force --trust --model %CURSOR_MODEL% --workspace "%~2" < "%~1" 2>&1
) else (
  cursor-agent.cmd -p --force --trust --model %CURSOR_MODEL% --workspace "%~2" < "%~1" > "%OUT%" 2>&1
)
set "RC=%ERRORLEVEL%"

endlocal & exit /b %RC%
