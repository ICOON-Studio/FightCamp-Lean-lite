@echo off
REM codex_task.cmd â€” the ONE permitted way Claude launches Codex on a task.
REM
REM Operator decision 2026-09-10: Codex joins Qwen and Grok as a directly
REM driven agent. The permission rule in .claude/settings.json points at THIS
REM wrapper rather than at `codex` generally, so what is granted is one fixed
REM invocation against this repo â€” not arbitrary Codex use.
REM
REM Usage:  Tools\codex_task.cmd <prompt-file> <last-message-out-file>
REM
REM The prompt is fed on stdin so a 6k-character task file needs no quoting.
REM Sandbox is workspace-write: Codex may edit this repo and run commands, but
REM the blunt --dangerously-bypass-approvals-and-sandbox flag is deliberately
REM NOT used here.
REM
REM OPERATOR RULE 2026-10-14 (S222, supersedes S184): "use astra 6.1 for codex" - gpt-6.1-astra is not offered on his ChatGPT account (400), he chose gpt-6-astra: hard-task model = gpt-6-astra (CODEX_MODEL=gpt-6-astra).
REM (old S184 rule, superseded: "do not use astra model for codex use sol6.1 instead").
REM OPERATOR RULE 2026-09-25 (supersedes 2026-09-13): default gpt-6-luna at LOW or MEDIUM; the 3D-animation / hard-task model is now gpt-6.1-sol at MEDIUM (was gpt-6-astra).
REM Both are pinned on the command line so no run inherits whatever
REM ~/.codex/config.toml says (it said gpt-5.6-sol). Do not change them here
REM without the operator's word.

setlocal

if "%~1"=="" (
  echo ERROR: no prompt file given. Usage: codex_task.cmd ^<prompt-file^> ^<out-file^>
  exit /b 2
)
if not exist "%~1" (
  echo ERROR: prompt file not found: %~1
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
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0agent_window.ps1" -Title "CODEX %~n1" -Command "%~f0" -ArgumentString "%~1|%~2" -DoneFile "%DONEF%"
set "RC=%ERRORLEVEL%"
if exist "%DONEF%" del "%DONEF%"
exit /b %RC%
:run_inline

set "CODEX=%APPDATA%\npm\codex.cmd"
if not exist "%CODEX%" (
  echo ERROR: codex CLI not found at %CODEX%  ^(npm install -g @openai/codex^)
  exit /b 2
)

REM WORKSPACE OVERRIDE (2026-09-20). The default is still the main checkout, but a task
REM that must not collide with the shared tree's uncommitted work sets CODEX_REPO to a
REM git worktree instead. Nothing else about the invocation changes.
set "REPO=E:\FightCamp\Lean"
if not "%CODEX_REPO%"=="" set "REPO=%CODEX_REPO%"
set "OUTLAST=%~2"
if "%OUTLAST%"=="" set "OUTLAST=%TEMP%\codex_last_message.txt"

REM MODEL. gpt-6-luna at medium (low for mechanical passes, CODEX_EFFORT=low) is the operator's 2026-09-25 default and stays the
REM default here. CODEX_MODEL / CODEX_EFFORT override it for a task the operator has
REM named a model for (gpt-6.1-sol; astra is banned, S184).
set "MODEL=gpt-6-luna"
if not "%CODEX_MODEL%"=="" set "MODEL=%CODEX_MODEL%"
set "EFFORT=medium"
if not "%CODEX_EFFORT%"=="" set "EFFORT=%CODEX_EFFORT%"

REM S72 (operator 2026-09-25: "codex should be able to its own research"): ~/.codex/config.toml
REM says web_search = "disabled". CODEX_WEB=live turns search on for ONE run; "cached" also valid.
REM S211 operator: "codex needs always to have access to everything" - web search ON for EVERY run; CODEX_WEB=disabled opts out.
if "%CODEX_WEB%"=="" set "CODEX_WEB=live"
if /I "%CODEX_WEB%"=="disabled" set "CODEX_WEB="
set "WEB="
if not "%CODEX_WEB%"=="" set "WEB=-c web_search=%CODEX_WEB%"

REM S133: a worktree's git metadata lives in the MAIN checkout's .git/worktrees/<name>, outside a D: worktree, so
REM workspace-write denied every commit/fetch (C226 run 1 stopped on it).
REM S211: ALWAYS writable - the main checkout's .git (worktree commits) and E:\FightCamp (tmp sheets, refs, downloads, cache).
REM CODEX_ADD_DIR adds one more writable directory.
set "ADDDIR=--add-dir "E:\FightCamp\Lean\.git" --add-dir "E:\FightCamp""
if not "%CODEX_ADD_DIR%"=="" if /I not "%CODEX_ADD_DIR%"=="E:\FightCamp\Lean\.git" set "ADDDIR=%ADDDIR% --add-dir "%CODEX_ADD_DIR%""

REM S188: CLI 0.162.0's sandbox setup re-ACLs every runtime under %LOCALAPPDATA%\OpenAI\Codex\runtimes; while the
REM Codex DESKTOP app is open it holds node_repl.exe there (os error 32) -> "helper_unknown_error: setup refresh had
REM errors" and NO shell command runs (SPLIT1+GATES1 died in 20 s). An empty LOCALAPPDATA for the CLI alone fixes it
REM (probe: git status ran) without touching the operator's app.
if not exist "E:\FightCamp\codex_localappdata" mkdir "E:\FightCamp\codex_localappdata"
set "LOCALAPPDATA=E:\FightCamp\codex_localappdata"

REM S219 operator: "give web acess to codex" (to talk to Ask Ludo itself). Every run gets a Playwright MCP browser: the operator's
REM Brave, HEADLESS (nothing on his screens), its own signed-in profile E:\FightCamp\codex_browser_profile (he signs in to Ludo once
REM there; never his main profile). CODEX_BROWSER=off opts out for one run.
set "BROWSER="
if /I not "%CODEX_BROWSER%"=="off" set BROWSER=-c "mcp_servers.browser.command='node'" -c "mcp_servers.browser.args=['E:\FightCamp\tools\npm\node_modules\@playwright\mcp\cli.js','--headless','--executable-path','C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe','--user-data-dir','E:\FightCamp\codex_browser_profile','--output-dir','E:\FightCamp\tmp\codex_browser','--viewport-size','1440,900']" -c mcp_servers.browser.startup_timeout_sec=60

REM S211: the standing toolkit note (Tools\codex_header.txt -> AgentComms\CODEX_TOOLKIT.md) goes in front of every prompt.
(type "%~dp0codex_header.txt" & type "%~f1") | "%CODEX%" exec -m %MODEL% -c model_reasoning_effort=%EFFORT% %WEB% %BROWSER% -s workspace-write %ADDDIR% -C "%REPO%" -o "%OUTLAST%" -

endlocal
