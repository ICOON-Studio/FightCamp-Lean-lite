# S261 (operator: "i want the tool to run everytime the windows start"): started at logon by the scheduled task
# "FightCamp RAM Trim" (hidden, idle priority). Every -Every seconds it reads physical RAM use; at -AbovePct or more it runs
# Tools/ram_trim.ps1 (background apps' idle pages out to the pagefile, never the foreground app or Godot), at most every -GapSec.
# Log: AgentComms/ram_trim.log. Independent of the heat governor, which also trims on a watchdog memory alarm.
param([int]$Every = 120, [int]$AbovePct = 85, [int]$GapSec = 300)
$ErrorActionPreference = "SilentlyContinue"
(Get-Process -Id $PID).PriorityClass = 'Idle'
$trim = Join-Path $PSScriptRoot 'ram_trim.ps1'
$log = Join-Path (Split-Path $PSScriptRoot -Parent) 'AgentComms\ram_trim.log'
function Log($m) { "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $m" | Add-Content -Encoding utf8 $log }
$last = [datetime]::MinValue
Log "start every=${Every}s above=${AbovePct}% gap=${GapSec}s"
while ($true) {
    $os = Get-CimInstance Win32_OperatingSystem
    $usedPct = [math]::Round(100 * (1 - $os.FreePhysicalMemory / $os.TotalVisibleMemorySize))
    if ($usedPct -ge $AbovePct -and ((Get-Date) - $last).TotalSeconds -ge $GapSec) {
        $last = Get-Date
        $res = (& powershell -NoProfile -ExecutionPolicy Bypass -File $trim 2>$null | Select-Object -Last 1)
        Log "RAM ${usedPct}% -> $res"
    }
    Start-Sleep -Seconds $Every
}
