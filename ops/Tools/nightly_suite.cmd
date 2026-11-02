@echo off
REM S259: RETIRED - the nightly runs on GitHub runners (.github/workflows/nightly-suite.yml, Tools/nightly_fetch.py);
REM the scheduled task "FightCamp Nightly Suite" is DISABLED. Kept for a cloud outage only.
REM nightly_suite.cmd - the ONE full-suite run per day (operator rule 2026-09-25:
REM "can we run the full suite only 1 time per day when i am asleep ?").
REM Registered as the Windows scheduled task "FightCamp Nightly Suite" (03:00).
REM Two jobs, not four: a daytime --jobs 4 run with agents working took the
REM Ryzen 7800X3D to 90 C. Output: AgentComms\nightly\suite_<date>.log (untracked);
REM latest.txt holds the SUITE line. Sessions read it instead of running the suite.
setlocal
cd /d "%~dp0.."
if not exist "AgentComms\nightly" mkdir "AgentComms\nightly"
for /f %%d in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set D=%%d
set FIGHTCAMP_STAGE_GATE=off
git rev-parse --short HEAD > "AgentComms\nightly\head_%D%.txt"
python Godot\tools\run_tests.py --jobs 2 > "AgentComms\nightly\suite_%D%.log" 2>&1
powershell -NoProfile -Command "$h=(Get-Content 'AgentComms\nightly\head_%D%.txt'); $s=(Select-String -Path 'AgentComms\nightly\suite_%D%.log' -Pattern '^SUITE' | Select-Object -Last 1).Line; if (-not $s) { $s='ABORTED - no SUITE line (S226: the run died; the FAIL lines below are partial, not a result)' }; $f=(Select-String -Path 'AgentComms\nightly\suite_%D%.log' -Pattern 'FAIL ' | ForEach-Object { $_.Line.Trim() }) -join [Environment]::NewLine; Set-Content -Encoding utf8 'AgentComms\nightly\latest.txt' ('%D% at ' + $h + ': ' + $s + [Environment]::NewLine + $f)"
REM S249: the nightly auto-revert. DRY RUN until the operator arms it (Tools\nightly_revert.py arm): it records what it WOULD revert.
python Tools\nightly_revert.py --apply > "AgentComms\nightly\revert_%D%.log" 2>&1
endlocal
