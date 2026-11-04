# pc_metrics.ps1 - live PC metrics for the ops board (operator S379, with a Task Manager screenshot: "can i have this
# metrics on board"). CPU %/GHz, memory, every physical disk (active %, response ms, read/write, free space), network,
# GPU 3D % and temperatures, every 2 s.
#
# ONE long-running process and no child process per sample: Get-Counter reads the Windows performance counters inside
# this process, LibreHardwareMonitor's local web server (http://127.0.0.1:8085, the watchdog's sensor source) gives the
# CPU/GPU temperatures, .NET DriveInfo the free space. The latest sample + the last $Keep (2 min) are written to
# AgentComms\pc_metrics.json (git-ignored machine state); the board serves it at /api/pc_metrics and draws it on / and /pc.
# Colours on the board are the watchdog's own thresholds (pc_watchdog.ps1) - this script only measures.
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
        if ([IO.File]::Exists($outFile)) { [IO.File]::Replace($tmpFile, $outFile, $null) } else { [IO.File]::Move($tmpFile, $outFile) }
    } catch {
        # The board had the file open at that instant: overwrite in place; the next sample comes in 2 s anyway.
        try { [IO.File]::Copy($tmpFile, $outFile, $true) } catch { LogErr "write: $($_.Exception.Message)" }
    }
}

Log "start pid=$PID every=${Every}s keep=$Keep"
$cycle = 0
while ($true) {
    # 30 samples (1 min) per Get-Counter call, then the wildcards are expanded again so GPU engines of processes started
    # since (a new Godot, a render) are counted. Still one process; the re-expansion costs ~0.3 s once a minute.
    try {
        Get-Counter -Counter $paths -SampleInterval $Every -MaxSamples 30 -ErrorAction SilentlyContinue |
            ForEach-Object { try { Write-Sample $_ } catch { LogErr "sample: $($_.Exception.Message)" } }
    } catch { LogErr "counter: $($_.Exception.Message)"; Start-Sleep -Seconds $Every }
    $cycle++
    $Error.Clear(); [GC]::Collect()   # vanished-instance errors pile up in $Error; keep the resident set flat
    if ($cycle % 10 -eq 0) { $diskInfo = Read-DiskInfo }
}
