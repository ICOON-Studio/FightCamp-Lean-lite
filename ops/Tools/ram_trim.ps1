# S261 RAM TRIM (operator: "can you make a tool to take advantage of the pagefile instead of the physical ram").
# Windows cannot run a program "from the pagefile", but it can be told to page out what background apps are not touching:
#   1. EmptyWorkingSet  - the app's unused pages leave physical RAM now (to the standby list / pagefile); RAM frees at once.
#   2. Memory priority LOW - when RAM runs short again, Windows takes it from these apps first.
# Never touched: the foreground window's process, Godot (our jobs), system/session processes, and anything not in -Names.
# Switching back to a trimmed app pulls its pages back in (a second of slowness); nothing is closed or lost.
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\ram_trim.ps1            # trim the default background set
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\ram_trim.ps1 -DryRun    # show what would be trimmed
param(
    [string[]]$Names = @("opera", "brave", "chrome", "msedge", "firefox", "ChatGPT", "node", "Codex", "Cursor", "Cici", "Grok", "Discord", "Spotify", "Teams", "slack"),
    [switch]$DryRun,
    [int]$MinMB = 50
)
$ErrorActionPreference = "SilentlyContinue"
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class RamTrim {
    [DllImport("psapi.dll", SetLastError=true)] public static extern bool EmptyWorkingSet(IntPtr h);
    [DllImport("kernel32.dll", SetLastError=true)] public static extern IntPtr OpenProcess(uint access, bool inherit, int pid);
    [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
    [DllImport("kernel32.dll", SetLastError=true)] public static extern bool SetProcessInformation(IntPtr h, int cls, ref uint info, uint size);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
    public static int ForegroundPid() { uint p; GetWindowThreadProcessId(GetForegroundWindow(), out p); return (int)p; }
}
"@
# PROCESS_SET_QUOTA 0x0100 | PROCESS_QUERY_LIMITED_INFORMATION 0x1000 | PROCESS_SET_INFORMATION 0x0200
$ACCESS = 0x0100 -bor 0x1000 -bor 0x0200
$ProcessMemoryPriority = 0
$MEMORY_PRIORITY_LOW = 2

$fg = [RamTrim]::ForegroundPid()
$fgName = (Get-Process -Id $fg).ProcessName
$os = Get-CimInstance Win32_OperatingSystem
$freeBefore = [math]::Round($os.FreePhysicalMemory / 1MB, 2)

$rows = @()
foreach ($p in Get-Process) {
    if ($p.Id -eq $fg -or $p.ProcessName -eq $fgName) { continue }          # the app he is using stays whole
    if ($p.ProcessName -like "Godot*") { continue }                         # our jobs
    if (-not ($Names | Where-Object { $p.ProcessName -like "$_*" })) { continue }
    $mb = [math]::Round($p.WorkingSet64 / 1MB)
    if ($mb -lt $MinMB) { continue }
    $ok = "dry"
    if (-not $DryRun) {
        $h = [RamTrim]::OpenProcess($ACCESS, $false, $p.Id)
        if ($h -eq [IntPtr]::Zero) { $ok = "denied" }
        else {
            $prio = [uint32]$MEMORY_PRIORITY_LOW
            [void][RamTrim]::SetProcessInformation($h, $ProcessMemoryPriority, [ref]$prio, 4)
            $ok = if ([RamTrim]::EmptyWorkingSet($h)) { "trimmed" } else { "failed" }
            [void][RamTrim]::CloseHandle($h)
        }
    }
    $rows += [pscustomobject]@{ Name = $p.ProcessName; Id = $p.Id; WorkingSetMB = $mb; Result = $ok }
}
Start-Sleep -Milliseconds 800
$os = Get-CimInstance Win32_OperatingSystem
$freeAfter = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$byName = $rows | Group-Object Name | ForEach-Object { "{0} x{1} {2} MB" -f $_.Name, $_.Count, ($_.Group | Measure-Object WorkingSetMB -Sum).Sum }
Write-Output ("RAM_TRIM foreground={0} (kept) processes={1} {2}" -f $fgName, $rows.Count, ($(if ($DryRun) { "DRY RUN" } else { "" })))
$byName | ForEach-Object { Write-Output "  $_" }
Write-Output ("RAM_TRIM free RAM {0} GB -> {1} GB (+{2} GB)" -f $freeBefore, $freeAfter, [math]::Round($freeAfter - $freeBefore, 2))
