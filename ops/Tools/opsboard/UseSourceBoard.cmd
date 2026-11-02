@echo off
REM Double-click this. It makes the ops board's "Run on this PC" button work.
REM
REM The board you look at is FightCampOpsBoard.exe, a frozen build: it serves
REM the checkout's page but its own server.py cannot change, so a page can
REM never add the /api/launch endpoint the button needs. This is the one thing
REM that has to happen on this PC, and it only happens once.
REM
REM SAFE BY DEFAULT: it starts a SECOND board from the checkout on port 8788 and
REM leaves the existing board on 8787 completely alone. Nothing to lose.
REM Pass -Replace later to move 8787 to the source too; -Undo puts it all back.
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0UseSourceBoard.ps1" %*
echo.
pause
