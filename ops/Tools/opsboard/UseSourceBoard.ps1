# Make the ops board's launch button work, from the checkout, permanently.
#
# WHY THIS EXISTS. The board the operator looks at is FightCampOpsBoard.exe, a
# PyInstaller freeze. R138 makes it serve the CHECKOUT's index.html on every
# request, so a `git pull` updates the PAGE - but server.py is frozen inside the
# binary, so a page can never add an endpoint to it. `POST /api/launch` does not
# exist on that server and cannot be made to. That is the whole reason a pulled
# board showed no working button: there is no page-only way to start a process.
#
# So exactly one thing has to happen on this PC, once. This is it.
#
# SAFE BY DEFAULT. The existing 'FightCamp Ops Board' task and the exe on 8787
# are NOT TOUCHED. A second task, 'FightCamp Ops Board (source)', runs the
# checkout's server.py on 8788 with the same self-healing five-minute trigger.
# If it fails you have lost nothing and the board you rely on is still up.
# Re-run with -Replace once you trust it and the ORIGINAL task is re-pointed at
# the source too, with its definition exported first and restored on any
# failure.
#
# NOT TESTED ON WINDOWS - written from a Linux container (Claude, 2026-09-15).
# Every step prints what it did, verifies the result over HTTP, and rolls back
# what it changed if the verification fails.

[CmdletBinding()]
param(
    [int]$Port = 8788,
    [switch]$Replace,
    [switch]$Undo,
    [switch]$Merge,
    [string]$Branch = 'claude/agent-comms-startup-lu8660'
)

$ErrorActionPreference = 'Stop'
$MainTask   = 'FightCamp Ops Board'
$SourceTask = 'FightCamp Ops Board (source)'

function Say([string]$m) { Write-Host $m }
function Fail([string]$m) { Write-Host "FAILED: $m" -ForegroundColor Red; exit 1 }

# --- where the repo is. Resolved FIRST, because the merge below needs it and
# --- needs no administrator, and the elevation step comes after.
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
if (-not (Test-Path (Join-Path $root 'HANDOFF.md'))) {
    Fail "this script is not inside the checkout - expected HANDOFF.md at $root"
}
Set-Location $root
Say "repo:   $root"

# --- -Merge: bring the checkout up to date, BEFORE elevating.
#
# The operator is never at this PC when a change is pushed, and nothing on the
# machine pulls - every command the board can run is read-only (verified
# 2026-09-15). So the one visit has to do everything, and three typed commands
# are two more chances to stop halfway.
#
# It runs UNELEVATED on purpose: merging needs no administrator, and an elevated
# shell is exactly where a credential helper is most likely to behave
# differently. Only the scheduled task below needs the elevation.
#
# It refuses on a dirty tree - agents work in this checkout, and a 2026-09-07
# stash wiped a finished-but-uncommitted stage off disk once already - and a
# merge that conflicts is aborted, never left half-applied.
if ($Merge) {
    $dirty = (git status --porcelain) -join "`n"
    if ($dirty.Trim()) {
        Say 'The working tree has uncommitted changes, so NOTHING was merged:'
        Say $dirty
        Say 'Commit or set those aside, then run this again.'
        exit 1
    }
    Say 'fetching origin...'
    git fetch origin 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { Fail 'git fetch failed - is there a network?' }
    $before = (git rev-parse --short HEAD)
    git merge --no-ff --no-edit "origin/$Branch" 2>&1 | ForEach-Object { Say "  $_" }
    if ($LASTEXITCODE -ne 0) {
        git merge --abort 2>&1 | Out-Null
        Fail "merging origin/$Branch conflicted; the merge was ABORTED and the checkout is untouched at $before."
    }
    $after = (git rev-parse --short HEAD)
    if ($before -eq $after) { Say "already up to date at $before" }
    else { Say "merged origin/$Branch : $before -> $after" }
}

# --- elevate, because a task registered -LogonType S4U cannot be edited without it
$me = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $me.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Say 'Re-launching as administrator (scheduled tasks need it)...'
    # -Merge is deliberately NOT forwarded: it has already run above, in the
    # user's own context. Forwarding it would merge twice, and the second one
    # would run elevated where a credential helper may not be the same.
    $argline = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"",
                 '-Port', $Port)
    if ($Replace) { $argline += '-Replace' }
    if ($Undo)    { $argline += '-Undo' }
    Start-Process powershell -Verb RunAs -ArgumentList $argline
    exit 0
}

# --- the python that will run the board
$server = Join-Path $root 'Tools\opsboard\server.py'
if (-not (Test-Path $server)) { Fail "server.py not found at $server" }

# pythonw runs it with no console window, which is what a background board wants.
$py = $null
foreach ($name in @('pythonw.exe', 'python.exe')) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) { $py = $cmd.Source; break }
}
if (-not $py) {
    foreach ($guess in @("$env:LOCALAPPDATA\Programs\Python\Python3*\pythonw.exe", 'C:\Python3*\pythonw.exe')) {
        $hit = Get-ChildItem $guess -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($hit) { $py = $hit.FullName; break }
    }
}
if (-not $py) { Fail 'no python found on PATH - the board cannot run from source without one' }
Say "python: $py"

$backup = Join-Path $root 'Tools\opsboard\_main_task_backup.xml'

function Probe([int]$p) {
    # /api/launch is the one endpoint only the source build has, so it is the
    # honest test of "is the new board actually up".
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Seconds 1
        try {
            $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 "http://127.0.0.1:$p/api/launch"
            if ($r.StatusCode -eq 200) { return $true }
        } catch { }
    }
    return $false
}

if ($Undo) {
    if (Get-ScheduledTask -TaskName $SourceTask -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $SourceTask -Confirm:$false
        Say "removed '$SourceTask'"
    }
    if (Test-Path $backup) {
        Register-ScheduledTask -Xml (Get-Content $backup -Raw) -TaskName $MainTask -Force | Out-Null
        Say "restored '$MainTask' from $backup"
    }
    Say 'done - the board is exactly as it was.'
    exit 0
}

# --- the safe half: a SECOND board, from source, on its own port
# NEITHER pythonw NOR cmd. BOTH WERE TRIED ON 2026-09-21 AND BOTH FAILED.
#
# PYTHONW WEDGES THIS SERVER, AND "listening but not serving" IS WHAT IT LOOKS
# LIKE. pythonw.exe is the GUI-subsystem build: it has NO console, so once the
# server has written enough to stdout the write blocks forever and the process
# stops answering while its listening socket stays open. On 2026-09-21 that gave
# a board on 8788 that accepted connections and closed every one of them, and
# the same server started by hand with python.exe served immediately.
#
# CMD /c FAILED TOO, differently: wrapping
# `"python" -u "server.py" --port N >> "log" 2>&1` in the outer quotes that /c
# needs makes cmd mis-parse the nested ones. The task returned 0x1 instantly and
# wrote NOTHING, so there was not even an error to read.
#
# So the server grew a `--log` argument and the task runs python.exe directly:
# no shell, nothing to quote, and finally something to READ when the board
# misbehaves. `-u` keeps it unbuffered so the log is current.
$pyExe   = $py -replace 'pythonw\.exe$', 'python.exe'
$log     = Join-Path $root 'AgentComms\opsboard.log'
$action  = New-ScheduledTaskAction -Execute $pyExe `
             -Argument "-u `"$server`" --port $Port --log `"$log`"" `
             -WorkingDirectory $root
$trigger = New-ScheduledTaskTrigger -AtLogOn
# NO -RepetitionDuration. [TimeSpan]::MaxValue serialises to
# P99999999DT23H59M59S and Task Scheduler REFUSES it outright -
# "The task XML contains a value which is incorrectly formatted or out of range"
# - which is why this script had never once run to completion on this PC.
# Omitting the duration is how you say "repeat forever", and it is exactly what
# the existing 'FightCamp Ops Board' task does: its XML carries <Interval>PT5M
# </Interval> with no <Duration> sibling at all.
$repeat  = New-ScheduledTaskTrigger -Once -At (Get-Date) `
             -RepetitionInterval (New-TimeSpan -Minutes 5)
$settings = New-ScheduledTaskSettingsSet -MultipleInstances IgnoreNew -ExecutionTimeLimit 0 `
             -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $SourceTask -Action $action -Trigger @($trigger, $repeat) `
    -Settings $settings -RunLevel Highest -Force | Out-Null
Start-ScheduledTask -TaskName $SourceTask
Say "registered and started '$SourceTask' -> port $Port"

if (-not (Probe $Port)) {
    Unregister-ScheduledTask -TaskName $SourceTask -Confirm:$false -ErrorAction SilentlyContinue
    Fail "the source board did not answer on $Port within 20s. Nothing was changed; '$MainTask' is untouched. Run '$py `"$server`" --port $Port' by hand to see the error."
}

$ip = (Get-NetIPAddress -AddressFamily IPv4 |
       Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
       Select-Object -First 1).IPAddress
Say ''
Say "THE BUTTON IS LIVE. On the phone open:  http://${ip}:$Port/"
Say "The old board is untouched on 8787."

if (-not $Replace) {
    Say ''
    Say "When you trust it, re-run this with -Replace and the ORIGINAL task moves to the source too,"
    Say "so 8787 gets the button and there is only one board again. -Undo puts everything back."
    exit 0
}

# --- the opt-in half: re-point the ORIGINAL task at the source, with a restore path
$main = Get-ScheduledTask -TaskName $MainTask -ErrorAction SilentlyContinue
if (-not $main) { Fail "'$MainTask' does not exist, so there is nothing to replace (the source board on $Port is up and fine)." }
Export-ScheduledTask -TaskName $MainTask | Set-Content -Path $backup -Encoding UTF8
Say "exported '$MainTask' to $backup"

Disable-ScheduledTask -TaskName $MainTask | Out-Null
Stop-Process -Name FightCampOpsBoard -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Set-ScheduledTask -TaskName $MainTask `
    -Action (New-ScheduledTaskAction -Execute $pyExe `
        -Argument "-u `"$server`" --port 8787 --log `"$log`"" `
        -WorkingDirectory $root) | Out-Null
Enable-ScheduledTask -TaskName $MainTask | Out-Null
Start-ScheduledTask -TaskName $MainTask

if (Probe 8787) {
    Unregister-ScheduledTask -TaskName $SourceTask -Confirm:$false -ErrorAction SilentlyContinue
    Say ''
    Say "8787 now runs from the checkout. One board, the button works, and it stays current with every git pull."
    Say "Removed '$SourceTask'; '$MainTask' can be restored from $backup or by re-running with -Undo."
} else {
    Register-ScheduledTask -Xml (Get-Content $backup -Raw) -TaskName $MainTask -Force | Out-Null
    Start-ScheduledTask -TaskName $MainTask
    Say ''
    Say "8787 did not come back from source, so '$MainTask' was RESTORED from its export and restarted."
    Say "The source board stays on $Port and the button works there."
}
