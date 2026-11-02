# pc_watchdog.ps1 - warn the operator BEFORE the PC lags (operator 2026-09-26: "i do not want this to happen ever
# again", "you need to give me warnings everytime the computer is low on memory or cpu usage or temp etc", "if have to
# close tabs let me know").
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1          # loop, every 60 s (logon task)
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once    # one check; exit 1 if RED
#
# Sessions run -Once BEFORE any heavy job (a Godot suite, a model install, a big download, an agent launch). RED means
# do not start it. The loop writes AgentComms\pc_health.txt (last reading) so any session can read it.
param([switch]$Once, [int]$Every = 60)

# Thresholds (warn = amber toast, crit = red toast; -Once exits 1 on any red).
$C_FREE_WARN_GB = 15; $C_FREE_CRIT_GB = 6
$RAM_WARN_PCT = 85;   $RAM_CRIT_PCT = 93
# S207: commit (RAM + pagefile) ran out at 4.3 GB free of 54.6 GB while RAM read only 76% - browsers held ~20 GB committed -
# and two Godot jobs died on "Parameter mem is null" / signal 11. Godot needs commit headroom, not just free RAM.
$COMMIT_WARN_GB = 8;  $COMMIT_CRIT_GB = 4
# Operator 2026-10-02: "I do not want the temperature to go above 80" and CPU load low enough that
# "I can use the computer without problems" - RED here blocks every new agent / test / render start.
$CPU_WARN_PCT = 60;   $CPU_CRIT_PCT = 80      # sustained: averaged over the sample window
# Operator 2026-10-02 (S144, later): "you can go upt to 84C" - RED at 84; AMBER 10 below.
$TEMP_WARN_C = 74;    $TEMP_CRIT_C = 84
# Operator S249 (to let more work run): "RED at 84 C only when held 2 minutes, instant stop at 88 C" - the governor log showed
# nearly every RED was a Godot burst that cleared in 60-90 s. 84+ is AMBER until it has HELD $TEMP_HOLD_S; 88+ (the 10 s
# window's low, one degree under the 7800X3D's own 89 C limit) is RED at once.
$TEMP_HARD_C = 88;    $TEMP_HOLD_S = 120
# S366 (E: froze the PC: a 480 GB DRAM-less SATA SSD at 96% full; one git repack of 9.5 GB of loose objects stalled every
# write ~1 s, E: 0% idle, and `start` and new sessions hung). E: free space and write latency are gates too.
$E_FREE_WARN_PCT = 15; $E_FREE_CRIT_PCT = 5; $E_WRITE_WARN_MS = 100; $E_WRITE_CRIT_MS = 250
# One hold clock for every watchdog call on this PC (loop, governor, rule_guard, any worktree): "<since> <last>" unix seconds.
$heatHoldFile = Join-Path $env:LOCALAPPDATA 'FightCamp\heat_hold.txt'
$REPEAT_MIN = 15                              # the same warning at most once per this many minutes

try { (Get-Process -Id $PID).PriorityClass = 'Idle' } catch {}
$root = Split-Path -Parent $PSScriptRoot
$healthFile = Join-Path $root 'AgentComms\pc_health.txt'
$historyFile = Join-Path $root 'AgentComms\pc_health_history.log'
$lastSent = @{}

function Start-LhmIfMissing {
    # Operator S197 "the heat meter on opsboard shows null": LHM does not autostart after a reboot. Its config starts it
    # minimised to the tray with the web server on, so starting it opens no window.
    $exe = 'C:\Tools\LibreHardwareMonitor\LibreHardwareMonitor.exe'
    if ((Test-Path $exe) -and -not (Get-Process -Name LibreHardwareMonitor -ErrorAction SilentlyContinue)) {
        try { Start-Process -FilePath $exe -WindowStyle Minimized -ErrorAction Stop; Start-Sleep -Seconds 6 } catch {}
    }
}

function Get-LhmTempC {
    try {
        $j = Invoke-RestMethod -Uri 'http://127.0.0.1:8085/data.json' -TimeoutSec 3 -ErrorAction Stop
        $vals = New-Object System.Collections.Generic.List[double]
        $stack = New-Object System.Collections.Stack; $stack.Push($j)
        while ($stack.Count -gt 0) {
            $n = $stack.Pop()
            if ($n.Text -match 'Tctl|Tdie|CPU Package|Core \(Tctl' -and "$($n.Value)" -match '([0-9]+[.,]?[0-9]*)\s*\u00B0C') {
                $vals.Add([double]($Matches[1] -replace ',', '.'))
            }
            foreach ($c in @($n.Children)) { if ($c) { $stack.Push($c) } }
        }
        if ($vals.Count) { return [math]::Round(($vals | Measure-Object -Maximum).Maximum, 0) }
    } catch {}
    return $null
}

# SUSTAINED TEMPERATURE (operator 2026-10-02: "yes make it sustained 10 seconds"). Tctl is the CPU's hottest
# spot and jumps 5-10 C in a second on a burst, so one sample tripped RED on spikes. When the first sample is
# at or above the AMBER line, take $TEMP_SAMPLES more over ~$TEMP_WINDOW_S seconds and judge the LOWEST:
# RED only when every sample in the 10 s window is at/above 84 C. The peak is reported beside it.
$TEMP_WINDOW_S = 10; $TEMP_SAMPLES = 4
function Get-SustainedTemp($first) {
    if ($first -eq $null -or $first -lt $TEMP_WARN_C) { return @($first, $first) }
    $all = @($first)
    for ($i = 0; $i -lt $TEMP_SAMPLES; $i++) {
        Start-Sleep -Milliseconds ([int](1000 * $TEMP_WINDOW_S / $TEMP_SAMPLES))
        $t = Get-LhmTempC; if ($t -ne $null) { $all += $t }
    }
    return @((($all | Measure-Object -Minimum).Minimum), (($all | Measure-Object -Maximum).Maximum))
}

function Get-Reading {
    $os = Get-CimInstance Win32_OperatingSystem
    $ramPct = [math]::Round(100 * (1 - $os.FreePhysicalMemory / $os.TotalVisibleMemorySize), 0)
    $commitFree = [math]::Round($os.FreeVirtualMemory / 1MB, 1)
    $cFree = [math]::Round((Get-PSDrive C).Free / 1GB, 1)
    # E: = hot data + agent worktrees (operator S197: "add e capacity on the board").
    $eFree = $null; try { $eFree = [math]::Round((Get-PSDrive E -ErrorAction Stop).Free / 1GB, 1) } catch {}
    $ePct = $null; try { $v = Get-Volume -DriveLetter E -ErrorAction Stop; $ePct = [math]::Round(100 * $v.SizeRemaining / $v.Size, 1) } catch {}
    # Write latency over ~2 s (a healthy SSD writes in < 5 ms; the S366 stall was ~1000 ms with the disk never idle).
    $eWriteMs = $null; $eIdle = $null
    try {
        $s = (Get-Counter -Counter '\PhysicalDisk(*)\Avg. Disk sec/Write', '\PhysicalDisk(*)\% Idle Time' -SampleInterval 1 -MaxSamples 2 -ErrorAction Stop).CounterSamples | Where-Object { $_.InstanceName -match 'e:' }
        $w = $s | Where-Object { $_.Path -match 'sec/write' } | Measure-Object -Property CookedValue -Average
        $i = $s | Where-Object { $_.Path -match 'idle time' } | Measure-Object -Property CookedValue -Average
        if ($w.Count) { $eWriteMs = [math]::Round(1000 * $w.Average, 0) }
        if ($i.Count) { $eIdle = [math]::Round([math]::Min(100, $i.Average), 0) }
    } catch {}
    # A git gc / repack writes gigabytes; S366's came from auto-gc on a fetch. Name any that runs.
    $packers = @(Get-CimInstance Win32_Process -Filter "Name='git.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match '\s(gc|repack|pack-objects|maintenance)(\s|$)' } | ForEach-Object { "pid $($_.ProcessId)" })
    $cpu = [math]::Round((Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average, 0)
    # CPU temperature: LibreHardwareMonitor's web server (http://127.0.0.1:8085, the CPU die sensor
    # "Tctl/Tdie" on this Ryzen 7800X3D) first; Windows' ACPI zone as a fallback. Speccy has no feed.
    $temp = $null; $tempSrc = ''; $tempPeak = $null
    $first = Get-LhmTempC
    if ($first -eq $null) { Start-LhmIfMissing; $first = Get-LhmTempC }
    if ($first -ne $null) { $pair = Get-SustainedTemp $first; $temp = $pair[0]; $tempPeak = $pair[1]; $tempSrc = 'LHM' }
    if ($temp -eq $null) {
        try {
            $z = Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop
            $temp = [math]::Round((($z | Measure-Object -Property CurrentTemperature -Maximum).Maximum / 10) - 273.15, 0)
            $tempSrc = 'ACPI'
        } catch {}
    }
    # Browsers are summed per name, so "brave 3.1 GB" means its tabs together.
    $procs = Get-Process | Group-Object Name | ForEach-Object {
        [pscustomobject]@{ Name = $_.Name; MB = [int](($_.Group | Measure-Object WorkingSet64 -Sum).Sum / 1MB) }
    } | Sort-Object MB -Descending | Select-Object -First 4
    [pscustomobject]@{ CommitFreeGB = $commitFree; RamPct = $ramPct; CFreeGB = $cFree; EFreeGB = $eFree; EFreePct = $ePct; EWriteMs = $eWriteMs; EIdle = $eIdle; Packers = $packers; CpuPct = $cpu; TempC = $temp; TempPeak = $tempPeak; TempSrc = $tempSrc; Top = $procs }
}

# Governor settings: 6 of 16 logical CPUs (0x3F = CPUs 0-5). Raise to 0xFF for 8 if runs are too slow and temps allow.
$HEAVY_CORES = 6; $HEAVY_MASK = [IntPtr]0x3F
$HEAVY_NAMES = '^(Godot_v.*|godot|blender)$'
function Set-HeavyAffinity {
    foreach ($p in Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -match $HEAVY_NAMES }) {
        try { if ($p.ProcessorAffinity -ne $HEAVY_MASK) { $p.ProcessorAffinity = $HEAVY_MASK } } catch {}
    }
}

## Seconds the CPU has stayed at/above $TEMP_CRIT_C, across calls. A reading below it clears the clock; a gap of more than
## 90 s between readings (the loop reads every 60 s) restarts it, so a stale file never turns into a RED.
function Get-HeatHoldSec($t) {
    $now = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    if ($t -eq $null -or $t -lt $TEMP_CRIT_C) {
        try { Remove-Item -LiteralPath $heatHoldFile -ErrorAction Stop } catch {}
        return 0
    }
    $since = $null; $last = $null
    try {
        $parts = (Get-Content -LiteralPath $heatHoldFile -TotalCount 1 -ErrorAction Stop) -split ' '
        $since = [long]$parts[0]; $last = [long]$parts[1]
    } catch {}
    if ($since -eq $null -or ($now - $last) -gt 90) { $since = $now }
    try {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $heatHoldFile) | Out-Null
        Set-Content -LiteralPath $heatHoldFile -Value "$since $now" -Encoding ascii
    } catch {}
    return [int]($now - $since)
}

function Get-Problems($r) {
    $p = @()
    if ($r.CFreeGB -lt $C_FREE_CRIT_GB) { $p += [pscustomobject]@{ Key='disk'; Red=$true;  Text="C: only $($r.CFreeGB) GB free - Windows will lag. Move or delete files on C:." } }
    elseif ($r.CFreeGB -lt $C_FREE_WARN_GB) { $p += [pscustomobject]@{ Key='disk'; Red=$false; Text="C: is getting full: $($r.CFreeGB) GB free." } }
    if ($r.EFreePct -ne $null -and $r.EFreePct -lt $E_FREE_CRIT_PCT) { $p += [pscustomobject]@{ Key='edisk'; Red=$true;  Text="E: only $($r.EFreeGB) GB free ($($r.EFreePct)%) - the E: SSD stalls this full (S366). Free space on E: before any heavy job." } }
    elseif ($r.EFreePct -ne $null -and $r.EFreePct -lt $E_FREE_WARN_PCT) { $p += [pscustomobject]@{ Key='edisk'; Red=$false; Text="E: is getting full: $($r.EFreeGB) GB free ($($r.EFreePct)%) - keep it under 85% used." } }
    $pk = if ($r.Packers) { " Git packer running: $($r.Packers -join ', ')." } else { '' }
    if ($r.EWriteMs -ne $null -and $r.EWriteMs -ge $E_WRITE_CRIT_MS -and $r.EIdle -ne $null -and $r.EIdle -lt 10) { $p += [pscustomobject]@{ Key='ewrite'; Red=$true;  Text="E: is stalled: writes take $($r.EWriteMs) ms (normal under 5), disk $($r.EIdle)% idle.$pk" } }
    elseif ($r.EWriteMs -ne $null -and $r.EWriteMs -ge $E_WRITE_WARN_MS) { $p += [pscustomobject]@{ Key='ewrite'; Red=$false; Text="E: writes are slow: $($r.EWriteMs) ms.$pk" } }
    elseif ($pk) { $p += [pscustomobject]@{ Key='ewrite'; Red=$false; Text=$pk.Trim() } }
    $top = ($r.Top | ForEach-Object { "$($_.Name) $([math]::Round($_.MB/1024,1)) GB" }) -join ', '
    $tabs = ''
    if ($r.Top | Where-Object { $_.Name -match 'brave|chrome|msedge|firefox|opera' -and $_.MB -gt 1500 }) { $tabs = ' Close some browser tabs.' }
    if ($r.CommitFreeGB -ne $null -and $r.CommitFreeGB -lt $COMMIT_CRIT_GB) { $p += [pscustomobject]@{ Key='commit'; Red=$true;  Text="Commit memory nearly full: $($r.CommitFreeGB) GB free (RAM + pagefile). Godot jobs crash here - close browser tabs. Biggest: $top" } }
    elseif ($r.CommitFreeGB -ne $null -and $r.CommitFreeGB -lt $COMMIT_WARN_GB) { $p += [pscustomobject]@{ Key='commit'; Red=$false; Text="Commit memory low: $($r.CommitFreeGB) GB free (RAM + pagefile)." } }
    if ($r.RamPct -ge $RAM_CRIT_PCT) { $p += [pscustomobject]@{ Key='ram'; Red=$true;  Text="Memory $($r.RamPct)% used. Biggest: $top.$tabs" } }
    elseif ($r.RamPct -ge $RAM_WARN_PCT) { $p += [pscustomobject]@{ Key='ram'; Red=$false; Text="Memory $($r.RamPct)% used. Biggest: $top.$tabs" } }
    if ($r.CpuPct -ge $CPU_CRIT_PCT) { $p += [pscustomobject]@{ Key='cpu'; Red=$true;  Text="CPU at $($r.CpuPct)% - pause an agent or a test run." } }
    elseif ($r.CpuPct -ge $CPU_WARN_PCT) { $p += [pscustomobject]@{ Key='cpu'; Red=$false; Text="CPU at $($r.CpuPct)%." } }
    if ($r.TempC -ne $null) {
        $held = Get-HeatHoldSec $r.TempC
        if ($r.TempC -ge $TEMP_HARD_C) { $p += [pscustomobject]@{ Key='temp'; Red=$true;  Text="Temperature $($r.TempC) C - hard stop at $TEMP_HARD_C C, stop heavy work now." } }
        elseif ($r.TempC -ge $TEMP_CRIT_C -and $held -ge $TEMP_HOLD_S) { $p += [pscustomobject]@{ Key='temp'; Red=$true;  Text="Temperature $($r.TempC) C held $held s (limit $TEMP_CRIT_C C for $TEMP_HOLD_S s) - stop heavy work now." } }
        elseif ($r.TempC -ge $TEMP_CRIT_C) { $p += [pscustomobject]@{ Key='temp'; Red=$false; Text="Temperature $($r.TempC) C, held $held of $TEMP_HOLD_S s - RED if it holds." } }
        elseif ($r.TempC -ge $TEMP_WARN_C) { $p += [pscustomobject]@{ Key='temp'; Red=$false; Text="Temperature $($r.TempC) C." } }
    }
    $p
}

function Send-Toast($title, $text) {
    try {
        Add-Type -AssemblyName System.Windows.Forms, System.Drawing
        $n = New-Object System.Windows.Forms.NotifyIcon
        $n.Icon = [System.Drawing.SystemIcons]::Warning
        $n.BalloonTipTitle = $title; $n.BalloonTipText = $text; $n.Visible = $true
        $n.ShowBalloonTip(15000); Start-Sleep -Seconds 16; $n.Dispose()
    } catch {}
}

function Write-Health($r, $problems) {
    $state = if ($problems | Where-Object Red) { 'RED' } elseif ($problems) { 'AMBER' } else { 'GREEN' }
    $top = ($r.Top | ForEach-Object { "$($_.Name)=$($_.MB)MB" }) -join ' '
    $line = "{0} {1} C_free={2}GB E_free={7}GB E_pct={9}% E_write={10}ms RAM={3}% COMMIT_free={8}GB CPU={4}% TEMP={5} top: {6}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $state, $r.CFreeGB, $r.RamPct, $r.CpuPct, $(if ($r.TempC -ne $null) { "$($r.TempC)C($($r.TempSrc))" + $(if ($r.TempPeak -ne $null -and $r.TempPeak -ne $r.TempC) { "[peak $($r.TempPeak)]" } else { '' }) } else { 'n/a' }), $top, $(if ($r.EFreeGB -ne $null) { $r.EFreeGB } else { 'n/a' }), $r.CommitFreeGB, $(if ($r.EFreePct -ne $null) { $r.EFreePct } else { 'n/a' }), $(if ($r.EWriteMs -ne $null) { $r.EWriteMs } else { 'n/a' })
    try { Set-Content -Path $healthFile -Value $line -Encoding utf8 } catch {}
    # S287 (PC froze 2026-10-22 22:06, nothing recorded the minutes before it): the loop keeps a history, ~10 days
    if (-not $Once) {
        try {
            Add-Content -Path $historyFile -Value $line -Encoding utf8
            if ((Get-Item $historyFile).Length -gt 3MB) { Set-Content -Path $historyFile -Value (Get-Content $historyFile -Tail 8000) -Encoding utf8 }
        } catch {}
    }
    foreach ($x in $problems) { $line += "`n  " + $(if ($x.Red) { 'RED   ' } else { 'AMBER ' }) + $x.Text }
    $line
    $state
}

if ($Once) {
    # S143 SANDBOX FALLBACK (operator 2026-10-02: "YOU DO THAT"). Inside Codex's workspace-write sandbox
    # Get-CimInstance is ACCESS DENIED and the reading came back C_free=0GB -> RED, so every sandboxed agent
    # stopped at its first watchdog (Q213B S143; C230/C232 digests). When CIM is denied, use the HOST's own last
    # reading - the MAIN checkout's AgentComms/pc_health.txt (not this worktree's copy), kept fresh by the host
    # loop Claude runs while agents work - if it is at most 10 minutes old. Older, missing or RED = RED: an
    # unknown PC is never green.
    $cimOk = $true
    try { $null = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop } catch { $cimOk = $false }
    if (-not $cimOk) {
        $common = (& git -C $root rev-parse --path-format=absolute --git-common-dir 2>$null)
        $mainRoot = if ($common) { Split-Path -Parent $common } else { $root }
        $hostFile = Join-Path $mainRoot 'AgentComms\pc_health.txt'
        if (Test-Path $hostFile) {
            $age = [int]((Get-Date) - (Get-Item $hostFile).LastWriteTime).TotalSeconds
            $hostLine = Get-Content $hostFile -TotalCount 1
            if ($age -le 600 -and $hostLine -match ' (GREEN|AMBER) ') {
                "SANDBOX (CIM denied) - host reading ${age}s old: $hostLine"
                exit 0
            }
            "RED SANDBOX (CIM denied) - host reading ${age}s old is stale or RED: $hostLine"
        } else { "RED SANDBOX (CIM denied) - no host reading at $hostFile" }
        exit 1
    }
    # Two CPU samples a few seconds apart so one spike does not read as load.
    # The first reading already spends up to 10 s on a sustained temperature window, which also spaces the CPU samples.
    $a = Get-Reading; Start-Sleep -Seconds 2; $TEMP_SAMPLES = 0; $b = Get-Reading   # b: one quick sample, a already held the window
    $b.CpuPct = [math]::Round(($a.CpuPct + $b.CpuPct) / 2, 0)
    if ($a.TempC -ne $null -and $b.TempC -ne $null) { $b.TempC = [math]::Min($a.TempC, $b.TempC); $b.TempPeak = [math]::Max($a.TempPeak, $b.TempPeak) }
    $out = Write-Health $b (Get-Problems $b)
    $out[0]
    if ($out[1] -eq 'RED') { exit 1 } else { exit 0 }
}

$cpuWindow = New-Object System.Collections.Generic.Queue[int]
while ($true) {
    $r = Get-Reading
    $cpuWindow.Enqueue($r.CpuPct); while ($cpuWindow.Count -gt 3) { [void]$cpuWindow.Dequeue() }
    $r.CpuPct = [math]::Round(($cpuWindow | Measure-Object -Average).Average, 0)   # 3-minute sustained load
    $problems = Get-Problems $r
    [void](Write-Health $r $problems)
    $due = @($problems | Where-Object { -not $lastSent.ContainsKey($_.Key) -or ((Get-Date) - $lastSent[$_.Key]).TotalMinutes -ge $REPEAT_MIN })
    if ($due.Count -gt 0) {
        $title = if ($due | Where-Object Red) { 'FightCamp PC: act now' } else { 'FightCamp PC: heads up' }
        Send-Toast $title (($due | ForEach-Object Text) -join "`n")
        foreach ($x in $due) { $lastSent[$x.Key] = Get-Date }
    }
    # HEAVY-JOB GOVERNOR (operator S144: "doing these test in serial instead of parallel would solve the issues ?").
    # One Godot/Blender run spreads over all 16 threads and alone takes this PC to 80-84 C; two at once stack. Pinning
    # EVERY Godot/Blender process to the same $HEAVY_CORES logical CPUs makes parallel runs SHARE them - the heat of
    # roughly one run, whoever launched them (agents' sandboxes cannot share a lock; this host loop can set affinity
    # on any process). Applied every 5 s so a new run is capped within seconds. Tests just take longer.
    for ($tick = 0; $tick -lt [math]::Max(1, [int]($Every / 5)); $tick++) {
        Set-HeavyAffinity
        Start-Sleep -Seconds 5
    }
}
