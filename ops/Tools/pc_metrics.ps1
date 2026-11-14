# pc_metrics.ps1 - live PC metrics for the ops board (operator S379, with a Task Manager screenshot: "can i have this
# metrics on board"). CPU %/GHz, memory, every physical disk (active %, response ms, read/write, free space), network,
# GPU 3D % and temperatures, every 2 s.
#
# ONE long-running process and no child process per sample: Get-Counter reads the Windows performance counters inside
# this process, LibreHardwareMonitor's local web server (http://127.0.0.1:8085, the watchdog's sensor source) gives the
# CPU/GPU temperatures, .NET DriveInfo the free space. The latest sample + the last $Keep (2 min) are written to
# AgentComms\pc_metrics.json (git-ignored machine state); the board serves it at /api/pc_metrics and draws it on / and /pc.
# Colours on the board are the watchdog's own thresholds (pc_watchdog.ps1) - this script only measures.
# S379 detail (operator: "you have way more info on metrics for the pc live"): every 3rd sample (6 s) it also writes
# AgentComms\pc_detail.json for the /pc page's lower half - see Write-Detail. Native half: pc_metrics_native.cs (Add-Type, once).
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_metrics.ps1             # the sampler (logon task)
#   powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_metrics.ps1 -Register   # (re)create the task + start it
#
# Scheduled task "FightCamp PC Metrics": at logon + a 5-min self-heal trigger (IgnoreNew), started through
# `conhost.exe --headless` like every FightCamp task (S336: a bare powershell.exe task opens a terminal window).
# RESTART after editing this file: Stop-ScheduledTask leaves the PowerShell child running (measured S379), so stop THAT pid -
# the powershell.exe whose command line names pc_metrics.ps1, never by image name - then Start-ScheduledTask $TaskName.
param([switch]$Register, [int]$Every = 2, [int]$Keep = 60)

$TaskName = 'FightCamp PC Metrics'
if ($Register) {
    $user = "$env:USERDOMAIN\$env:USERNAME"
    $arg = '--headless powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'
    $action = New-ScheduledTaskAction -Execute 'conhost.exe' -Argument $arg
    $logon = New-ScheduledTaskTrigger -AtLogOn -User $user
    $heal = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5)
    $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit ([TimeSpan]::Zero) `
        -MultipleInstances IgnoreNew -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger @($logon, $heal) -Principal $principal -Settings $settings `
        -Description 'Ops board live PC metrics (S379): one hidden Get-Counter loop -> ops\AgentComms\pc_metrics.json every 2 s' -Force | Out-Null
    Start-ScheduledTask -TaskName $TaskName
    Get-ScheduledTask -TaskName $TaskName | ForEach-Object { '{0} | {1} | {2} {3}' -f $_.TaskName, $_.State, $_.Actions[0].Execute, $_.Actions[0].Arguments }
    exit 0
}

# One sampler at a time (a manual run beside the task would double the writes).
$mutex = New-Object System.Threading.Mutex($false, 'FightCampPcMetricsSampler')
if (-not $mutex.WaitOne(0)) { exit 0 }

$ErrorActionPreference = 'SilentlyContinue'
try { (Get-Process -Id $PID).PriorityClass = 'BelowNormal' } catch {}   # stays live under load, never competes with work
$root = Split-Path -Parent $PSScriptRoot
$outFile = Join-Path $root 'AgentComms\pc_metrics.json'
$tmpFile = $outFile + '.tmp'
$logFile = Join-Path $root 'AgentComms\pc_metrics.log'
$inv = [Globalization.CultureInfo]::InvariantCulture
$utf8 = New-Object System.Text.UTF8Encoding($false)
$lastErr = [datetime]::MinValue
function Log($m) { try { [IO.File]::AppendAllText($logFile, (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + " $m`r`n", $utf8) } catch {} }
function LogErr($m) { if (((Get-Date) - $script:lastErr).TotalSeconds -ge 300) { $script:lastErr = Get-Date; Log "error: $m" } }
function N($v, [int]$d = 1) {
    if ($v -eq $null) { return 'null' }
    $x = [double]$v
    if ([double]::IsNaN($x) -or [double]::IsInfinity($x)) { return 'null' }
    return ([math]::Round($x, $d)).ToString($inv)
}
function S([string]$s) { return '"' + ($s -replace '\\', '\\' -replace '"', '\"') + '"' }

# --- facts read once (and the disks again every 10 min: offline / type) ---------------------------------------------------
$ramTotalGB = $null; $cpuName = ''; $gpuName = ''
try { $ramTotalGB = (Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB } catch {}
try { $cpuName = ((Get-CimInstance Win32_Processor | Select-Object -First 1).Name).Trim() } catch {}
try { $gpuName = (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual|Parsec' } | Select-Object -First 1).Name } catch {}
$diskInfo = @{}
function Read-DiskInfo {
    $m = @{}
    try {
        $off = @{}; Get-Disk | ForEach-Object { $off["$($_.Number)"] = [bool]$_.IsOffline }
        Get-PhysicalDisk | ForEach-Object {
            $id = "$($_.DeviceId)"
            # MediaType reads "Unspecified" for the offline WD Green (S190) - anything not an SSD is the spinning disk.
            $type = if ("$($_.MediaType)" -eq 'SSD') { 'SSD' } else { 'HDD' }
            $m[$id] = @{ model = "$($_.FriendlyName)".Trim(); type = $type; bus = "$($_.BusType)"; size_gb = $_.Size / 1GB; offline = [bool]$off[$id] }
        }
    } catch {}
    return $m
}
$diskInfo = Read-DiskInfo
# Adapter names as Task Manager shows them ("Ethernet" + its model); the counter instance is the model, lower-case, with
# PDH's character swaps.
$nicNames = @{}
try {
    Get-NetAdapter | ForEach-Object {
        $k = ("$($_.InterfaceDescription)" -replace '\(', '[' -replace '\)', ']' -replace '[#/\\]', '_').ToLower()
        $nicNames[$k] = @{ name = "$($_.Name)"; desc = "$($_.InterfaceDescription)" }
    }
} catch {}

$paths = @(
    '\Processor Information(_Total)\% Processor Utility',      # what Task Manager calls CPU utilisation
    '\Processor Information(_Total)\% Processor Performance',  # x base MHz = the current speed (GHz)
    '\Processor Information(_Total)\Processor Frequency',
    '\Memory\Available MBytes',
    '\Memory\Committed Bytes',
    '\Memory\Commit Limit',
    '\PhysicalDisk(*)\% Idle Time',                            # active time = 100 - idle
    '\PhysicalDisk(*)\Avg. Disk sec/Transfer',                 # average response time
    '\PhysicalDisk(*)\Disk Read Bytes/sec',
    '\PhysicalDisk(*)\Disk Write Bytes/sec',
    '\Network Interface(*)\Bytes Received/sec',
    '\Network Interface(*)\Bytes Sent/sec',
    '\GPU Engine(*engtype_3D)\Utilization Percentage'          # one instance per process x engine - summed
)
$sensorRx = [regex]'"Text":"([^"]*)","Min":"[^"]*","Value":"([0-9]+(?:[.,][0-9]+)?)[^"]*","Max":"[^"]*","SensorId":"([^"]+)"'
$wc = New-Object System.Net.WebClient
$hist = New-Object System.Collections.Generic.List[string]
$nicBytes = @{}

function Read-Lhm {
    # One local GET of LHM's JSON (~70 KB) and a regex over it - no JSON parse, no process. $null values when LHM is down.
    $r = @{ cpu_c = $null; gpu_c = $null; gpu_hot = $null }
    try {
        $t = $wc.DownloadString('http://127.0.0.1:8085/data.json')
        foreach ($m in $sensorRx.Matches($t)) {
            $text = $m.Groups[1].Value; $v = [double]($m.Groups[2].Value -replace ',', '.'); $sid = $m.Groups[3].Value
            if ($sid -match '^/(amd|intel)cpu/\d+/temperature/' -and $text -match 'Tctl|Tdie|CPU Package') {
                if ($r.cpu_c -eq $null -or $v -gt $r.cpu_c) { $r.cpu_c = $v }   # the hottest, like the watchdog
            } elseif ($sid -match '^/gpu-[^/]+/\d+/temperature/') {
                if ($text -eq 'GPU Core' -and $r.gpu_c -eq $null) { $r.gpu_c = $v }
                elseif ($text -eq 'GPU Hot Spot' -and $r.gpu_hot -eq $null) { $r.gpu_hot = $v }
            }
        }
    } catch {}
    return $r
}

function Write-Sample($set) {
    $now = [DateTimeOffset]::Now
    $cpu = $null; $perf = $null; $freq = $null; $avail = $null; $commit = $null; $limit = $null; $gpu = 0.0; $gpuSeen = $false
    $disk = @{}; $rx = 0.0; $tx = 0.0; $nicNow = @{}
    foreach ($c in $set.CounterSamples) {
        if ($c.Status -gt 1) { continue }   # 0 valid, 1 new data; anything else = a vanished instance
        $p = $c.Path; $v = $c.CookedValue
        if ($p -like '*\gpu engine(*') { $gpu += $v; $gpuSeen = $true; continue }
        if ($p -like '*\physicaldisk(*') {
            $inst = $c.InstanceName; if ($inst -eq '_total') { continue }
            if (-not $disk.ContainsKey($inst)) { $disk[$inst] = @{} }
            if ($p -like '*% idle time') { $disk[$inst].act = [math]::Max(0, [math]::Min(100, 100 - $v)) }
            elseif ($p -like '*sec/transfer') { $disk[$inst].ms = 1000 * $v }
            elseif ($p -like '*read bytes/sec') { $disk[$inst].rd = $v }
            elseif ($p -like '*write bytes/sec') { $disk[$inst].wr = $v }
            continue
        }
        if ($p -like '*\network interface(*') {
            $inst = $c.InstanceName; $nicNow[$inst] = 1
            if ($p -like '*received/sec') { $rx += $v } else { $tx += $v }
            $nicBytes[$inst] = [double]$nicBytes[$inst] + $v
            continue
        }
        if ($p -like '*% processor utility') { $cpu = [math]::Min(100, $v) }
        elseif ($p -like '*% processor performance') { $perf = $v }
        elseif ($p -like '*processor frequency') { $freq = $v }
        elseif ($p -like '*available mbytes') { $avail = $v }
        elseif ($p -like '*committed bytes') { $commit = $v }
        elseif ($p -like '*commit limit') { $limit = $v }
    }
    $ghz = if ($perf -ne $null -and $freq -ne $null) { $freq * $perf / 100000 } else { $null }
    $memUsed = if ($ramTotalGB -ne $null -and $avail -ne $null) { $ramTotalGB - $avail / 1024 } else { $null }
    $memPct = if ($memUsed -ne $null) { 100 * $memUsed / $ramTotalGB } else { $null }
    $lhm = Read-Lhm
    $temps.Add($(if ($lhm.cpu_c -ne $null) { [double]$lhm.cpu_c } else { [double]::NaN })); $tempsS.Add((N $lhm.cpu_c 1))
    while ($temps.Count -gt $TempKeep) { $temps.RemoveAt(0); $tempsS.RemoveAt(0) }
    $script:lastS = @{ commit = $commit; limit = $limit; ram = $ramTotalGB; used = $memUsed; cpu_c = $lhm.cpu_c }

    # Disks: instance "0 e:" = disk 0 holding E:; free space from every letter on it.
    $dj = New-Object System.Collections.Generic.List[string]
    $sj = New-Object System.Collections.Generic.List[string]
    foreach ($inst in ($disk.Keys | Sort-Object)) {
        $parts = $inst -split ' '; $n = $parts[0]
        $letters = @($parts | Select-Object -Skip 1 | ForEach-Object { $_.ToUpper() })
        $free = $null; $size = $null
        foreach ($l in $letters) {
            try { $d = New-Object System.IO.DriveInfo($l); if ($d.IsReady) { $free = [double]$free + $d.AvailableFreeSpace; $size = [double]$size + $d.TotalSize } } catch {}
        }
        $fp = if ($size) { 100 * $free / $size } else { $null }
        $x = $disk[$inst]
        $dj.Add('{"n":' + $n + ',"act":' + (N $x.act 1) + ',"ms":' + (N $x.ms 1) + ',"rd":' + (N $x.rd 0) + ',"wr":' + (N $x.wr 0) +
                ',"free_gb":' + (N $(if ($free -ne $null) { $free / 1GB }) 1) + ',"free_pct":' + (N $fp 1) + '}')
        $i = $diskInfo[$n]
        $sj.Add('{"n":' + $n + ',"letters":' + (S ($letters -join ' ')) + ',"model":' + (S $i.model) + ',"type":' + (S $i.type) + ',"bus":' + (S $i.bus) +
                ',"size_gb":' + (N $(if ($size) { $size / 1GB } else { $i.size_gb }) 1) + ',"offline":' + $(if ($i.offline) { 'true' } else { 'false' }) + '}')
    }
    $nic = ($nicBytes.GetEnumerator() | Where-Object { $nicNow[$_.Key] } | Sort-Object Value -Descending | Select-Object -First 1).Key
    $nn = $nicNames["$nic".ToLower()]

    $t = $now.ToUnixTimeMilliseconds() / 1000
    $sample = '{"t":' + (N $t 1) + ',"cpu":' + (N $cpu 1) + ',"ghz":' + (N $ghz 2) + ',"cpu_c":' + (N $lhm.cpu_c 1) +
        ',"mem_gb":' + (N $memUsed 2) + ',"mem_pct":' + (N $memPct 1) + ',"commit_gb":' + (N $(if ($commit -ne $null) { $commit / 1GB }) 2) +
        ',"commit_limit_gb":' + (N $(if ($limit -ne $null) { $limit / 1GB }) 2) +
        ',"disks":[' + ($dj -join ',') + '],"net_rx":' + (N $rx 0) + ',"net_tx":' + (N $tx 0) +
        ',"gpu":' + (N $(if ($gpuSeen) { [math]::Min(100, $gpu) }) 1) + ',"gpu_c":' + (N $lhm.gpu_c 1) + ',"gpu_hot":' + (N $lhm.gpu_hot 1) + '}'
    $hist.Add($sample); while ($hist.Count -gt $Keep) { $hist.RemoveAt(0) }

    $static = '{"cpu_name":' + (S $cpuName) + ',"ram_gb":' + (N $ramTotalGB 1) + ',"gpu_name":' + (S $gpuName) + ',"nic":' + (S $(if ($nn) { $nn.name } else { $nic })) + ',"nic_desc":' + (S $(if ($nn) { $nn.desc } else { '' })) +
        ',"disks":[' + ($sj -join ',') + ']}'
    $json = '{"ok":true,"v":1,"at":' + (S $now.ToString('yyyy-MM-dd HH:mm:ss', $inv)) + ',"t":' + (N $t 1) + ',"every_s":' + $Every +
        ',"keep":' + $Keep + ',"pid":' + $PID + ',"static":' + $static + ',"latest":' + $sample + ',"history":[' + ($hist -join ',') + ']}'
    try {
        [IO.File]::WriteAllText($tmpFile, $json, $utf8)
        if ([IO.File]::Exists($outFile)) { [IO.File]::Replace($tmpFile, $outFile, [NullString]::Value) } else { [IO.File]::Move($tmpFile, $outFile) }
    } catch {
        # The board had the file open at that instant: overwrite in place; the next sample comes in 2 s anyway.
        try { [IO.File]::Copy($tmpFile, $outFile, $true) } catch { LogErr "write: $($_.Exception.Message)" }
    }
}

# --- S379 detail: the /pc page's lower half (operator: "you have way more info on metrics for the pc live") -----------------------
# Every $DetailEvery samples (6 s) AgentComms\pc_detail.json gets:
#   verdict  AgentComms\pc_verdict.json as `pc_watchdog.ps1 -Once` last wrote it (the heat governor runs -Once every ~15 s) - the
#            pill, every reason line as printed, when the colour changed. This sampler never runs the watchdog itself.
#   procs    what is using the PC: pc_metrics_native.cs (one NtQuerySystemInformation call; each process named for a human).
#   runs     live_runs.json's running rows (re-read only when the file changes) and how long each has run.
#   mem      the page file(s) from Win32_PageFileUsage - every 5 min, or a minute after the commit limit moves (= the page file
#            grew or shrank) - and every size change seen; commit and its limit come from the counters above.
#   heat     10 min of CPU temperature (the 2 s samples), its peak, the heat governor's held jobs and its last log line.
#   folders  the largest folders under E:\FightCamp: one background-priority scan at most once an hour (~1 s, 120k files, S379),
#            cached in AgentComms\pc_folders.json so a restart does not rescan. Never on a page load.
#   cost     this sampler's own CPU over the last minute (% of one core), shown on the page.
$DetailEvery = 3; $TempKeep = [int](600 / $Every); $FolderRoot = 'E:\FightCamp'; $FolderEveryS = 3600
$temps = New-Object System.Collections.Generic.List[double]; $tempsS = New-Object System.Collections.Generic.List[string]
$nSample = 0; $lastS = @{}
$detailFile = Join-Path $root 'AgentComms\pc_detail.json'; $detailTmp = $detailFile + '.tmp'
$verdictFile = Join-Path $root 'AgentComms\pc_verdict.json'
$healthFile = Join-Path $root 'AgentComms\pc_health.txt'
$runsFile = Join-Path $root 'AgentComms\live_runs.json'
$foldersFile = Join-Path $root 'AgentComms\pc_folders.json'
$govLog = Join-Path $root 'AgentComms\heat_governor.log'
$govPaused = Join-Path ([IO.Path]::GetTempPath()) 'fightcamp_heat_paused.txt'
$native = $false
try { Add-Type -Path (Join-Path $PSScriptRoot 'pc_metrics_native.cs') -ErrorAction Stop; $native = $true } catch { Log "native helper failed: $($_.Exception.Message)" }
if ($native) { $null = [FcPc.Procs]::Json() }   # the first read only sets each process's CPU baseline
$runsStamp = [datetime]::MinValue; $runRows = @()
$pfAuto = $null; try { $pfAuto = [bool](Get-CimInstance Win32_ComputerSystem).AutomaticManagedPagefile } catch {}
$pfAt = [datetime]::MinValue; $pfLimit = $null; $pfSize = $null; $pfJson = '[]'; $pfEvents = New-Object System.Collections.Generic.List[string]
$govStamp = [datetime]::MinValue; $govLine = ''
$foldersJson = 'null'; $foldersLast = ''; $foldersNext = 0.0
try { $c = [IO.File]::ReadAllText($foldersFile, $utf8); if ($c -match '"at":(\d+)') { $foldersJson = $c; $foldersLast = $c; $foldersNext = [double]$Matches[1] + $FolderEveryS } } catch {}
$me = [Diagnostics.Process]::GetCurrentProcess()
$costQ = New-Object System.Collections.Generic.Queue[object]

function Read-Runs {
    try { $st = [IO.File]::GetLastWriteTimeUtc($runsFile) } catch { return }
    if ($st -eq $script:runsStamp) { return }
    $script:runsStamp = $st
    $rows = @()
    try {
        $j = [IO.File]::ReadAllText($runsFile, $utf8) | ConvertFrom-Json
        foreach ($pr in $j.runs.PSObject.Properties) {
            $r = $pr.Value
            if ("$($r.status)" -ne 'running') { continue }
            $started = $null
            try { $started = [datetime]::ParseExact("$($r.started)", [string[]]@("yyyy-MM-dd'T'HH:mm", "yyyy-MM-dd'T'HH:mm:ss", 'yyyy-MM-dd HH:mm'), $inv, 'None') } catch {}
            $wt = if ($r.worktree) { "$($r.worktree)" } elseif ($r.wt) { "$($r.wt)" } else { '' }
            $rows += [pscustomobject]@{ id = $pr.Name; agent = "$($r.agent)"; title = "$($r.title)"; started = $started; eta = "$($r.eta)"; wt = $wt }
        }
    } catch { LogErr "live_runs: $($_.Exception.Message)" }
    $script:runRows = $rows
    if ($native) { [FcPc.Procs]::SetRuns([string[]]@($rows | ForEach-Object { $_.id }), [string[]]@($rows | ForEach-Object { $_.agent }), [string[]]@($rows | ForEach-Object { $_.wt })) }
}

function Write-Detail {
    $now = [DateTimeOffset]::Now; $t = $now.ToUnixTimeMilliseconds() / 1000; $L = $script:lastS
    Read-Runs
    $procs = if ($native) { [FcPc.Procs]::Json() } else { 'null' }
    $runs = @(foreach ($r in $script:runRows) {
        $mins = if ($r.started) { [math]::Max(0, ($now.LocalDateTime - $r.started).TotalMinutes) } else { $null }
        '{"id":' + (S $r.id) + ',"agent":' + (S $r.agent) + ',"title":' + (S $r.title) + ',"started":' + (S $(if ($r.started) { $r.started.ToString('HH:mm', $inv) } else { '' })) +
            ',"mins":' + (N $mins 0) + ',"eta":' + (S $r.eta) + ',"wt":' + (S $r.wt) + '}'
    })
    $verdict = 'null'; $vAge = $null
    try { $v = [IO.File]::ReadAllText($verdictFile, $utf8).Trim(); if ($v.StartsWith('{') -and $v.EndsWith('}')) { $verdict = $v; $vAge = ($now.UtcDateTime - [IO.File]::GetLastWriteTimeUtc($verdictFile)).TotalSeconds } } catch {}
    $health = ''; $hAge = $null
    try { $health = ([IO.File]::ReadAllText($healthFile, $utf8) -split "`r?`n")[0].Trim([char]0xFEFF, ' '); $hAge = ($now.UtcDateTime - [IO.File]::GetLastWriteTimeUtc($healthFile)).TotalSeconds } catch {}

    # Page file: CIM only every 5 min, or a minute after the commit limit moved (the limit = RAM + page file, so a move = growth).
    $limitGb = if ($L.limit -ne $null) { $L.limit / 1GB } else { $null }
    $since = ((Get-Date) - $script:pfAt).TotalSeconds
    if ($since -ge 300 -or ($since -ge 60 -and $limitGb -ne $null -and $script:pfLimit -ne $null -and [math]::Abs($limitGb - $script:pfLimit) -ge 0.25)) {
        $script:pfAt = Get-Date; $script:pfLimit = $limitGb
        try {
            $u = @(Get-CimInstance Win32_PageFileUsage -ErrorAction Stop)
            # Its set sizes: a file may grow from its initial to its maximum size (0 = Windows manages it).
            $set = @{}; try { Get-CimInstance Win32_PageFileSetting -ErrorAction Stop | ForEach-Object { $set["$($_.Name)".ToLower()] = $_ } } catch {}
            $script:pfJson = '[' + (@($u | ForEach-Object { $ps = $set["$($_.Name)".ToLower()]
                '{"name":' + (S "$($_.Name)") + ',"alloc_mb":' + [int]$_.AllocatedBaseSize + ',"use_mb":' + [int]$_.CurrentUsage + ',"peak_mb":' + [int]$_.PeakUsage +
                ',"init_mb":' + $(if ($ps) { [int]$ps.InitialSize } else { 0 }) + ',"max_mb":' + $(if ($ps) { [int]$ps.MaximumSize } else { 0 }) + '}' }) -join ',') + ']'
            $size = [int](($u | Measure-Object AllocatedBaseSize -Sum).Sum)
            if ($script:pfSize -ne $null -and $size -ne $script:pfSize) {
                $script:pfEvents.Insert(0, '{"t":' + (N $t 0) + ',"at":' + (S $now.ToString('HH:mm', $inv)) + ',"from_mb":' + $script:pfSize + ',"to_mb":' + $size + '}')
                while ($script:pfEvents.Count -gt 5) { $script:pfEvents.RemoveAt(5) }
            }
            $script:pfSize = $size
        } catch { LogErr "pagefile: $($_.Exception.Message)" }
    }
    $mem = '{"ram_gb":' + (N $L.ram 1) + ',"used_gb":' + (N $L.used 2) + ',"commit_gb":' + (N $(if ($L.commit -ne $null) { $L.commit / 1GB }) 2) + ',"limit_gb":' + (N $limitGb 2) +
        ',"auto":' + $(if ($script:pfAuto -eq $null) { 'null' } elseif ($script:pfAuto) { 'true' } else { 'false' }) + ',"files":' + $script:pfJson + ',"events":[' + ($script:pfEvents -join ',') + ']}'

    # Heat: the 10-min peak and when; the governor's held jobs (its own file) and last log line (read only when it changed).
    $pi = if ($native) { [FcPc.J]::PeakIndex($script:temps) } else { -1 }
    $peak = if ($pi -ge 0) { $script:temps[$pi] } else { $null }
    $peakAgo = if ($pi -ge 0) { ($script:temps.Count - 1 - $pi) * $Every } else { $null }
    $held = 0; try { $held = @([IO.File]::ReadAllLines($govPaused) | Where-Object { $_.Trim() }).Count } catch {}
    try {
        $gs = [IO.File]::GetLastWriteTimeUtc($govLog)
        if ($gs -ne $script:govStamp) {
            $script:govStamp = $gs
            $fs = New-Object IO.FileStream($govLog, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]'ReadWrite, Delete')
            try { $n = [int][math]::Min(2048, $fs.Length); [void]$fs.Seek(-$n, [IO.SeekOrigin]::End); $b = New-Object byte[] $n; [void]$fs.Read($b, 0, $n) } finally { $fs.Dispose() }
            $script:govLine = @(($utf8.GetString($b) -split "`r?`n") | Where-Object { $_.Trim() })[-1]
        }
    } catch {}

    # Folder sizes: hourly, background thread; the answer is cached on disk.
    if ($native) {
        $fr = [FcPc.Folders]::Result
        if ($fr -and $fr -ne $script:foldersLast) {
            $script:foldersLast = $fr; $script:foldersJson = $fr
            try { [IO.File]::WriteAllText($foldersFile, $fr, $utf8) } catch {}
        }
        if (-not [FcPc.Folders]::Running -and $t -ge $script:foldersNext -and (Test-Path -LiteralPath $FolderRoot)) {
            $script:foldersNext = $t + $FolderEveryS; [void][FcPc.Folders]::Start($FolderRoot)
        }
    }

    # What this sampler costs: its own CPU over the last minute, % of one core.
    $me.Refresh(); $cpuMs = $me.TotalProcessorTime.TotalMilliseconds
    $script:costQ.Enqueue(@($t, $cpuMs)); while ($script:costQ.Count -gt 11) { [void]$script:costQ.Dequeue() }
    $first = $script:costQ.Peek(); $cost = if ($t -gt $first[0]) { 100 * ($cpuMs - $first[1]) / 1000 / ($t - $first[0]) } else { $null }

    $json = '{"ok":true,"v":1,"at":' + (S $now.ToString('yyyy-MM-dd HH:mm:ss', $inv)) + ',"t":' + (N $t 1) + ',"every_s":' + ($Every * $DetailEvery) + ',"pid":' + $PID +
        ',"native":' + $(if ($native) { 'true' } else { 'false' }) + ',"verdict":' + $verdict + ',"verdict_age_s":' + (N $vAge 0) +
        ',"health":' + (S $health) + ',"health_age_s":' + (N $hAge 0) + ',"procs":' + $procs + ',"runs":[' + ($runs -join ',') + '],"mem":' + $mem +
        ',"heat":{"every_s":' + $Every + ',"temps":[' + ($script:tempsS -join ',') + '],"now":' + (N $L.cpu_c 1) + ',"peak":' + (N $peak 1) +
        ',"peak_ago_s":' + (N $peakAgo 0) + ',"held":' + $held + ',"gov":' + (S $script:govLine) + '}' +
        ',"folders":' + $script:foldersJson + ',"folders_running":' + $(if ($native -and [FcPc.Folders]::Running) { 'true' } else { 'false' }) +
        ',"cost_pct":' + (N $cost 2) + '}'
    try {
        [IO.File]::WriteAllText($detailTmp, $json, $utf8)
        if ([IO.File]::Exists($detailFile)) { [IO.File]::Replace($detailTmp, $detailFile, [NullString]::Value) } else { [IO.File]::Move($detailTmp, $detailFile) }
    } catch { try { [IO.File]::Copy($detailTmp, $detailFile, $true) } catch { LogErr "detail write: $($_.Exception.Message)" } }
}

# S469 (operator: "Yes, log it"): Windows held 2 million leaked security tokens (pool tag Toke, ~5.8 GB) and no test named
# the program. Once a minute: the live token count beside what is running -> AgentComms\token_log.csv (git-ignored). Read the
# jumps (the `delta` column) against the columns to its right. Remove this block once the leak is named.
$tokenLog = Join-Path $root 'AgentComms\token_log.csv'; $script:tokePrev = -1; $poolOk = $false
try { . (Join-Path $PSScriptRoot 'pool_tags.ps1') | Out-Null; $poolOk = $true } catch { Log "pool tags helper failed: $($_.Exception.Message)" }
function Write-TokenLog {
    $line = [PoolTags]::Top(4000) | Where-Object { $_ -like 'Toke *' } | Select-Object -First 1
    if (-not ($line -match '\(\s*([\d,]+) live')) { return }
    $n = [int64]($Matches[1] -replace ',', '')
    $delta = if ($script:tokePrev -ge 0) { $n - $script:tokePrev } else { 0 }; $script:tokePrev = $n
    $ps = Get-Process; $c = @{}
    foreach ($k in 'Godot', 'conhost', 'powershell', 'python', 'node', 'chrome', 'claude', 'git', 'qwen', 'cmd') { $c[$k] = @($ps | Where-Object { $_.ProcessName -like "$k*" }).Count }
    if (-not (Test-Path -LiteralPath $tokenLog)) { [IO.File]::AppendAllText($tokenLog, "time,tokens,delta,processes,godot,conhost,powershell,python,node,chrome,claude,git,qwen,cmd`r`n", $utf8) }
    [IO.File]::AppendAllText($tokenLog, ((Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $n, $delta, $ps.Count, $c['Godot'], $c['conhost'], $c['powershell'], $c['python'], $c['node'], $c['chrome'], $c['claude'], $c['git'], $c['qwen'], $c['cmd'] -join ',') + "`r`n", $utf8)
}
Log "start pid=$PID every=${Every}s keep=$Keep"
$cycle = 0
while ($true) {
    # 30 samples (1 min) per Get-Counter call, then the wildcards are expanded again so GPU engines of processes started
    # since (a new Godot, a render) are counted. Still one process; the re-expansion costs ~0.3 s once a minute.
    try {
        Get-Counter -Counter $paths -SampleInterval $Every -MaxSamples 30 -ErrorAction SilentlyContinue |
            ForEach-Object {
                try { Write-Sample $_ } catch { LogErr "sample: $($_.Exception.Message)" }
                $script:nSample++
                if ($script:nSample % $DetailEvery -eq 0) { try { Write-Detail } catch { LogErr "detail: $($_.Exception.Message)" } }
            }
    } catch { LogErr "counter: $($_.Exception.Message)"; Start-Sleep -Seconds $Every }
    $cycle++
    if ($poolOk) { try { Write-TokenLog } catch { LogErr "token log: $($_.Exception.Message)" } }
    $Error.Clear(); [GC]::Collect()   # vanished-instance errors pile up in $Error; keep the resident set flat
    if ($cycle % 10 -eq 0) { $diskInfo = Read-DiskInfo }
}
