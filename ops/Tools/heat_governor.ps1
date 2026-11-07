# heat_governor.ps1 - keep the PC under the operator's 84 C limit whoever started the heat (S217).
# S249 (operator: "RED at 84 C only when held 2 minutes, instant stop at 88 C"): RED now comes from pc_watchdog.ps1 -Once,
# which holds 84+ as AMBER for 120 s (shared hold clock) and is RED at once at 88+ - this loop needs no change of its own.
#
# S217: two agent Godot jobs at once took the CPU to 84-88 C twice in one hour. The written rule "watchdog before every
# heavy job" cannot stop an AGENT's own Godot child. This loop enforces it: on RED it SUSPENDS the newest running Godot
# process (never kills - the job continues later); once RED has been gone for -CoolSec it RESUMES the oldest suspended one
# (GREEN or AMBER - S217: with 3 agents the PC sits AMBER, and a GREEN-only resume froze two agent tests indefinitely).
# Log: AgentComms/heat_governor.log. Run hidden:
#   powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File Tools\heat_governor.ps1
param([int]$Every = 15, [int]$CoolSec = 60)
$ErrorActionPreference = 'SilentlyContinue'
$root = Split-Path -Parent $PSScriptRoot
$log = Join-Path $root 'AgentComms\heat_governor.log'
$watchdog = Join-Path $PSScriptRoot 'pc_watchdog.ps1'
Add-Type -Namespace FCG -Name Nt -MemberDefinition @'
[DllImport("ntdll.dll")] public static extern int NtSuspendProcess(IntPtr h);
[DllImport("ntdll.dll")] public static extern int NtResumeProcess(IntPtr h);
'@
$paused = [System.Collections.ArrayList]@()   # PIDs this governor suspended, oldest first
# S235: the PIDs held right now, one per line, for run_tests.py - a test frozen here is not "hung" (the nightly's fight_contact_stop,
# boxing_output, fight_cc_skin "hangs" were all governor suspensions counted against the wall-clock timeout).
$pausedFile = Join-Path ([System.IO.Path]::GetTempPath()) 'fightcamp_heat_paused.txt'
function Publish { Set-Content -Encoding ascii -Path $pausedFile -Value (@($paused) -join "`n") }
Publish
$lastRed = [datetime]::MinValue
function Log($m) { "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $m" | Add-Content -Encoding utf8 $log }
$trim = Join-Path $PSScriptRoot 'ram_trim.ps1'
$lastTrim = [datetime]::MinValue
function State {
    $line = (& powershell -NoProfile -ExecutionPolicy Bypass -File $watchdog -Once 2>$null | Select-Object -Last 1)
    # S261 (operator: "make a tool to take advantage of the pagefile instead of the physical ram"): when the reason is MEMORY,
    # page out the background apps' idle memory first (Tools/ram_trim.ps1: 1.9 -> 8.9 GB free, RED -> GREEN measured), at most
    # every 5 min, and read the watchdog again - a Godot job is suspended only if RED survives the trim.
    if (($line -match '\b(RED|AMBER)\b') -and ($line -match 'Memory') -and ((Get-Date) - $script:lastTrim).TotalSeconds -ge 300) {
        $script:lastTrim = Get-Date
        $res = (& powershell -NoProfile -ExecutionPolicy Bypass -File $trim 2>$null | Select-Object -Last 1)
        Log "memory -> $res"
        Start-Sleep -Seconds 15
        $line = (& powershell -NoProfile -ExecutionPolicy Bypass -File $watchdog -Once 2>$null | Select-Object -Last 1)
    }
    if ($line -match '\bRED\b') { 'RED' } elseif ($line -match '\bAMBER\b') { 'AMBER' } else { 'GREEN' }
}
# S398 (operator "Yes, cap the cores"): the 7800X3D sat at 77-80 C on 40-50% load, so jobs were paused and resumed all
# afternoon. When the PC is not GREEN, every scripted job (Godot --script/--headless, the eyes video indexer and its ffmpeg)
# is pinned to 6 of the 16 threads (cores 2-4, both SMT threads; cores 0-1 stay free for Windows and his apps). A pinned
# job keeps its cap for life (jobs are short; no flapping). His own Godot (editor, no --script) is never touched.
$CapMask = [IntPtr]0x3F0
$capped = @{}
function CapJobs {
    Get-CimInstance Win32_Process -Filter "Name LIKE 'Godot%' OR Name='python.exe' OR Name='ffmpeg.exe'" | ForEach-Object {
        $id = [int]$_.ProcessId; $c = [string]$_.CommandLine; $n = [string]$_.Name
        if ($capped.ContainsKey($id)) { return }
        $job = (($n -like 'Godot*') -and ($c -match '--script|--headless') -and ($c -notmatch '--editor|\s-e(\s|$)|--remote-debug')) -or
               (($n -eq 'python.exe') -and ($c -match 'eyes(\.exe)?["\s]')) -or
               (($n -eq 'ffmpeg.exe') -and $capped.ContainsKey([int]$_.ParentProcessId))   # only the indexer's ffmpeg, never his
        if (-not $job) { return }
        $p = Get-Process -Id $id
        if ($p) { try { $p.ProcessorAffinity = $CapMask; $capped[$id] = $true; Log "CAP 6 threads pid=$id $n" } catch {} }
    }
    foreach ($id in @($capped.Keys)) { if (-not (Get-Process -Id $id)) { $capped.Remove($id) } }
}
Log "start every=${Every}s"
while ($true) {
    $s = State
    if ($s -ne 'GREEN') { CapJobs }
    foreach ($id in @($paused)) { if (-not (Get-Process -Id $id)) { [void]$paused.Remove($id) } }
    if ($s -eq 'RED') {
        $lastRed = Get-Date
        # S227: ONLY scripted jobs (--script / --headless: agent runs, tests, renders). It froze the OPERATOR's own Godot (no args,
        # started 23:15 - his editor/game) at 23:52, 23:59 and 00:31 while he played; an interactive Godot is never touched.
        $jobs = @{}; Get-CimInstance Win32_Process -Filter "Name LIKE 'Godot%'" | ForEach-Object {
            $c = [string]$_.CommandLine
            if (($c -match '--script|--headless') -and ($c -notmatch '--editor|\s-e(\s|$)|--remote-debug')) { $jobs[[int]$_.ProcessId] = $true } }
        $running = Get-Process | Where-Object { $_.ProcessName -like 'Godot*' -and $paused -notcontains $_.Id -and $jobs.ContainsKey([int]$_.Id) } |
            Sort-Object StartTime -Descending
        if ($running) {
            $p = $running[0]
            [void][FCG.Nt]::NtSuspendProcess($p.Handle); [void]$paused.Add($p.Id)
            Log "RED -> suspended pid=$($p.Id) started=$($p.StartTime.ToString('HH:mm:ss')) cmd=$((Get-CimInstance Win32_Process -Filter "ProcessId=$($p.Id)").CommandLine)"
        }
    } elseif ($paused.Count -gt 0 -and ((Get-Date) - $lastRed).TotalSeconds -ge $CoolSec) {
        $id = $paused[0]; $p = Get-Process -Id $id
        if ($p) { [void][FCG.Nt]::NtResumeProcess($p.Handle); Log "$s ${CoolSec}s after RED -> resumed pid=$id" }
        [void]$paused.RemoveAt(0)
    }
    Publish
    Start-Sleep -Seconds $Every
}
