# agent_window.ps1 - launch an agent in a console window the operator can SEE.
#
# OPERATOR REQUEST 2026-09-20: "i want to be able to see the agents clis when
# they work". Codex, Cursor and Qwen were launched headless with stdout
# redirected to a file, so there was nothing on screen.
#
#   Tools\agent_window.ps1 -Title "CODEX C136" -Command "Tools\codex_task.cmd" -Arguments @("<prompt>","<out>")
#
# WHY THIS IS POWERSHELL AND NOT cmd's `start`, MEASURED 2026-09-20 AND NOT
# GUESSED. Claude's own shell runs in a HIDDEN console, and `start "T" cmd /k`
# inherits that hidden state: the child process runs correctly and its window
# never appears. A window enumeration (EnumWindows + IsWindowVisible) found
# zero visible agent windows after a `start` launch and exactly one after a
# Start-Process launch. Start-Process sets the window state explicitly through
# STARTUPINFO instead of inheriting it, so it is the only form that works from
# here. Do not "simplify" this back to `start`.
#
# The window is opened with `cmd /k` so it STAYS OPEN when the run ends and the
# transcript can still be read. It returns as soon as the window opens, not
# when the agent finishes - so its exit code says nothing about the run. Read
# the out-file, never the rc.

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Title,
    [Parameter(Mandatory = $true)][string]$Command,
    [string[]]$Arguments = @(),
    # THE ONLY FORM A .cmd CALLER CAN ACTUALLY USE.
    #
    # `powershell -File script.ps1 -Arguments 'a','b'` does NOT bind an array:
    # -File takes its arguments as LITERAL strings, so the parameter receives
    # the one string `a,b`, and the launcher then runs with a single
    # comma-joined path that does not exist. That is exactly how the three
    # agent launchers failed - codex_task.cmd reported rc=2, its code for
    # "prompt file not found", while a self-test using ONE argument passed.
    #
    # So a cmd caller passes ONE string delimited by `|`, which is ILLEGAL in
    # a Windows path and therefore cannot occur inside an argument.
    [string]$ArgumentString = "",
    [string]$WorkingDirectory = "",
    [hashtable]$Environment = @{},
    # Block until the agent finishes, WITHOUT closing its window.
    #
    # The window is opened with `cmd /k` so the operator can still read the
    # transcript after the run ends - which means that cmd.exe never exits, and
    # waiting on the PROCESS would wait forever. So the inner command line
    # writes its exit code into a sentinel file the moment the agent returns,
    # and this waits on the FILE instead. One waiter, bounded, owned by the
    # caller - never a second loop watching the same file.
    [string]$DoneFile = "",
    [int]$TimeoutSeconds = 5400,
    # Print the exact command line this would run, and launch nothing. The
    # first version of the sentinel wait shipped green against a synthetic
    # self-test and then failed on the real launchers, so being able to SEE
    # the constructed line is not a debugging luxury here.
    [switch]$ShowCommand
)

if ($ArgumentString -ne "") {
    $Arguments = $ArgumentString.Split('|') | Where-Object { $_ -ne "" }
}

if (-not (Test-Path $Command)) {
    Write-Error "command not found: $Command"
    exit 2
}

# S198 THE WATCHDOG GATE LIVES HERE, not in the caller (CLAUDE.md s4: "RED does not launch"). Twice (S192, S198) a session
# chained the watchdog check and the launch in one command, the check printed RED, and the agent launched anyway because
# nothing read its exit code. Every launch goes through this script, so it refuses here. AMBER still launches (operator
# 2026-10-02: "launch with amber"). -ShowCommand launches nothing and skips the check.
if (-not $ShowCommand) {
    $watchdog = Join-Path $PSScriptRoot "pc_watchdog.ps1"
    if (Test-Path $watchdog) {
        ## Capture ALL output, then read the exit code: piping into Select-Object -First stops the child early and
        ## $LASTEXITCODE comes back -1, which would let a RED through (measured S198).
        $lines = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $watchdog -Once 2>&1)
        $watchdogRc = $LASTEXITCODE
        $reading = if ($lines.Count) { [string]$lines[0] } else { "" }
        if ($watchdogRc -eq 1) {
            Write-Output "REFUSED '$Title': PC watchdog is RED - $reading"
            exit 3
        }
    }
}

# REFUSE AN ARGUMENT THAT IS NOT THERE, rather than launch an agent that will
# fail three minutes later with a confusing error. A comma inside what should
# be a lone path is the signature of the -File binding bug above.
foreach ($a in $Arguments) {
    if ($a -like "*,*" -and $a -notlike "* *") {
        Write-Error "argument looks comma-joined, not split: $a`nUse -ArgumentString 'a|b'."
        exit 2
    }
}

# Environment for the child. Start-Process does not take an env table, so the
# variables are set into this process first - the child inherits them, and this
# process is short-lived, so nothing leaks past the launch.
foreach ($key in $Environment.Keys) {
    Set-Item -Path "Env:$key" -Value ([string]$Environment[$key])
}

# Quote every argument that contains a space. The task files and out-files live
# under paths with spaces in them ("Documents\ChatGPT\Game", "AppData\Local"),
# so an unquoted argument is not a rare case here - it is the normal one.
$quoted = foreach ($a in $Arguments) {
    if ($a -match '\s') { '"' + $a + '"' } else { $a }
}
$inner = ('"' + $Command + '"') + $(if ($quoted) { ' ' + ($quoted -join ' ') } else { '' })

# `title` inside the window as well as the Start-Process title, so the name
# shows in the window chrome and on the taskbar both.
$cmdLine = "title $Title && $inner"

if ($DoneFile -ne "") {
    if (Test-Path $DoneFile) { Remove-Item -LiteralPath $DoneFile -Force }
    # `&` not `&&`: the sentinel must be written whether the agent succeeded or
    # failed. With `&&` a failing run would never write it and the caller would
    # sit out the whole timeout on a run that died in ten seconds.
    # `!ERRORLEVEL!`, NOT `%ERRORLEVEL%`, and the window therefore needs
    # `cmd /v:on`. cmd expands `%VAR%` when it PARSES the line - which is
    # before the agent has run - so `%ERRORLEVEL%` writes the exit code of
    # whatever ran previously, every time. Measured: it wrote an empty string
    # and the launcher reported a failed run as clean.
    $cmdLine = $cmdLine + " & echo !ERRORLEVEL!> """ + $DoneFile + """" +
               " & echo. & echo [agent finished - this window closes itself]"
}

if ($ShowCommand) {
    Write-Output "cmd.exe /v:on /c <<<$cmdLine>>>"
    exit 0
}

# ONE STRING, NOT AN ARRAY. `Start-Process -ArgumentList @('/v:on','/k',$line)`
# joins the array itself and re-quotes each element, and $line is FULL of
# double quotes (around the command path and the sentinel path). PowerShell
# mangles those on the way to cmd, which is why the real launchers died with
# `'M' is not recognized` while a synthetic self-test whose arguments happened
# to contain no quotes passed. Building the single string here means what cmd
# receives is what was written.
$startArgs = @{
    FilePath     = 'cmd.exe'
    # /v:on enables !DELAYED! expansion, which the sentinel write needs.
    # /c, NOT /k (operator 2026-09-26: "close all admin cells that you do not
    # need" - six finished agent windows had piled up, each an Administrator
    # cmd kept open by /k). The window closes when the run ends; the transcript
    # is the out-file, and the DoneFile sentinel still carries the exit code.
    ArgumentList = "/v:on /c $cmdLine"
    # HIDDEN (operator 2026-09-30, S131, on the empty "Administrator: Windows
    # PowerShell" windows: "i do not want to see these at all they pop up and they
    # stay without showing what they do"). 'Minimized' (2026-09-25) is ignored by
    # Windows Terminal, the default console host on this PC - it opened a full,
    # blank window (the agent's output goes to its out-file). A HIDDEN console is
    # never handed to Windows Terminal. The agent's work is its out-file + worktree.
    WindowStyle  = 'Hidden'
    PassThru     = $true
}
if ($WorkingDirectory -ne "") { $startArgs['WorkingDirectory'] = $WorkingDirectory }

# S139 (operator: "wtf are all these photos popping up all the time"): agents opened their stills in the Photos app.
# Every agent launch makes sure the viewer guard runs (it exits at once if one is already running).
$guard = Join-Path $PSScriptRoot 'no_popups.ps1'
if (Test-Path $guard) {
    Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $guard | Out-Null
}

$proc = Start-Process @startArgs
# Operator 2026-09-25: the PC sat at 87% CPU with agents running. The agent's
# window runs at IDLE priority and every child it starts (Godot, Blender, node)
# inherits it, so the operator's own programs always win the CPU.
try { $proc.PriorityClass = 'Idle' } catch { }
Write-Output "launched '$Title' pid=$($proc.Id)"

if ($DoneFile -eq "") { exit 0 }

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
while ((Get-Date) -lt $deadline) {
    if (Test-Path $DoneFile) {
        # The file APPEARS before its contents are flushed, so a single read
        # here returns empty and an empty rc would be reported as success -
        # a failed agent run called clean. Re-read until it has content.
        $rc = ""
        foreach ($try in 1..10) {
            $raw = Get-Content -LiteralPath $DoneFile -Raw -ErrorAction SilentlyContinue
            if ($null -ne $raw -and $raw.Trim() -ne "") { $rc = $raw.Trim(); break }
            Start-Sleep -Milliseconds 300
        }
        if ($rc -match '^\d+$') {
            Write-Output "'$Title' finished rc=$rc"
            exit [int]$rc
        }
        Write-Output "'$Title' finished but wrote NO EXIT CODE - treat as failed, read the out-file."
        exit 5
    }
    if ($proc.HasExited) {
        # The window was closed by hand before the agent finished. Say so -
        # a missing sentinel is not the same as a clean run, and reporting it
        # as one is how a task gets called assigned when it never ran.
        Write-Output "'$Title' WINDOW CLOSED before the agent finished - no exit code. Read the out-file."
        exit 3
    }
    Start-Sleep -Seconds 3
}
Write-Output "'$Title' TIMED OUT after $TimeoutSeconds s - the window is still open, read it."
exit 4
