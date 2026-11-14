@echo off
REM qwen_task.cmd - the ONE permitted way Claude launches Qwen on a task.
REM
REM Written 2026-09-20 so Qwen launches the same way Codex and Cursor already do,
REM and so it can run inside Tools\agent_window.cmd where the operator can watch
REM it ("i want to be able to see the agents clis when they work"). Before this,
REM Qwen was launched as an ad-hoc PowerShell pipe, which meant the flags were
REM retyped at every launch and could drift.
REM
REM Usage:  Tools\qwen_task.cmd <prompt-file> <workspace-dir> [out-file]
REM
REM OPERATOR SETTINGS, PINNED HERE so no launch inherits something else:
REM   qwen3-coder at medium, --yolo.
REM
REM --yolo AND NOT --approval-mode auto. `auto` leaves Qwen with no shell tool
REM at all, which looks like a model failure and is a flag mistake. Do not
REM "fix" this to auto.
REM
REM READ THE OUT FILE, NEVER THE RC. Qwen prints a yolo warning that makes the
REM shell report exit 1 on a perfectly successful run. The rc from this wrapper
REM is worth nothing; the transcript is the evidence.

setlocal

if "%~1"=="" (
  echo ERROR: no prompt file given. Usage: qwen_task.cmd ^<prompt-file^> ^<workspace-dir^> [out-file]
  exit /b 2
)
if not exist "%~1" (
  echo ERROR: prompt file not found: %~1
  exit /b 2
)
if "%~2"=="" (
  echo ERROR: no workspace given. Usage: qwen_task.cmd ^<prompt-file^> ^<workspace-dir^> [out-file]
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
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0agent_window.ps1" -Title "QWEN %~n1" -Command "%~f0" -ArgumentString "%~1|%~2|%~3" -DoneFile "%DONEF%"
set "RC=%ERRORLEVEL%"
if exist "%DONEF%" del "%DONEF%"
exit /b %RC%
:run_inline

set "QWEN=%LOCALAPPDATA%\qwen-code\bin\qwen.cmd"
if not exist "%QWEN%" (
  echo ERROR: qwen CLI not found at %QWEN%
  exit /b 2
)

set "OUT=%~3"
if "%OUT%"=="" set "OUT=%TEMP%\qwen_task_last.txt"

REM RESOLVE THE PROMPT TO AN ABSOLUTE PATH *BEFORE* THE `cd` BELOW, AND THE
REM OUTPUT TOO (2026-09-22, S52). The `if not exist "%~1"` guard at the top
REM runs in the REPO ROOT and passes; `type "%~1"` five lines down runs in the
REM WORKTREE, where a relative prompt path does not resolve. The result is
REM "The system cannot find the file specified.", an agent started on EMPTY
REM STDIN, and `exit /b 0` - a silent no-op that looks exactly like a clean
REM run. Q137 was launched into that and came back in three minutes having
REM done nothing. The guard cannot catch it because the guard and the read
REM happen in different directories.
set "PROMPT=%~f1"
for %%O in ("%OUT%") do set "OUT=%%~fO"

REM Qwen runs FROM its worktree - it is given no --workspace flag, so the
REM working directory is what scopes it.
cd /d "%~2"

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
REM S138: QWEN_MODEL overrides the model for one run (design work needs a VISION model to see its own renders -
REM qwen3-coder is text-only). Default stays qwen3-coder.
set "QMODEL=qwen3-coder"
if not "%QWEN_MODEL%"=="" set "QMODEL=%QWEN_MODEL%"
REM S214: note the model this launch runs, for the model-router live view (127.0.0.1:4101).
for %%I in ("%~2") do set "FC_WT=%%~nxI"
if not exist "C:\Users\user\.claude\mods\model-router-live\agents" mkdir "C:\Users\user\.claude\mods\model-router-live\agents"
(echo %QMODEL%)> "C:\Users\user\.claude\mods\model-router-live\agents\%FC_WT%.txt"
REM S473 operator: "use also ollama on thebest free model available" - QWEN_LOCAL=1 runs the same CLI against the local
REM Ollama (OpenAI-style endpoint, no account, no cost): model qwen3-coder-fc:30b unless QWEN_MODEL names another.
set "QLOCAL="
if "%QWEN_LOCAL%"=="1" (
  if "%QWEN_MODEL%"=="" set "QMODEL=qwen3-coder-fc:30b"
  set "OLLAMA_API_KEY=ollama"
  set "QLOCAL=--auth-type openai --openai-base-url http://127.0.0.1:11434/v1 --openai-api-key ollama"
)
if "%FIGHTCAMP_AGENT_STREAM%"=="1" (
  type "%PROMPT%" | "%QWEN%" --yolo %QLOCAL% -m %QMODEL%
) else (
  type "%PROMPT%" | "%QWEN%" --yolo %QLOCAL% -m %QMODEL% > "%OUT%" 2>&1
)

endlocal
