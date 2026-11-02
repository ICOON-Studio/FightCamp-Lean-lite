# no_popups.ps1 - close the image-viewer windows agents pop up on the operator's monitors.
#
# Operator 2026-10-02 (S139): "stop the windows popping up on my other monitor" / "wtf are all these photos popping up
# all the time". Cause: agents told to "OPEN every still" launched the PNG in its default app (start / Invoke-Item /
# os.startfile) instead of reading it with their file tool - seven Microsoft Photos windows in two hours.
# The rule is in every brief now; this guard catches a run that ignores it.
#
# Runs hidden at IDLE priority. Every 2 s it closes Photos (and Paint) processes STARTED AFTER the guard began, so a
# viewer the operator already had open is left alone. To view pictures yourself while it runs, create
# AgentComms/allow_viewers.flag (the guard pauses while the file exists) or stop it:
#   Get-CimInstance Win32_Process | ? { $_.CommandLine -match 'no_popups.ps1' } | % { Stop-Process -Id $_.ProcessId }
# Start (Claude does this at session start):
#   Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','Tools\no_popups.ps1'
param([int]$IntervalSeconds = 2)

$ErrorActionPreference = 'SilentlyContinue'
try { (Get-Process -Id $PID).PriorityClass = 'Idle' } catch { }
$repo = Split-Path -Parent $PSScriptRoot
$flag = Join-Path $repo 'AgentComms\allow_viewers.flag'
$log = Join-Path $repo 'AgentComms\no_popups.log'
$since = Get-Date
$names = '^(Photos|Microsoft\.Photos|mspaint|PaintStudio\.View)$'

# S274 (operator: "why chrome is not opening"): a Godot/Ziva job on the hidden desktop (godot_desktop.ps1) opened a
# link while Chrome was closed, so Chrome's MAIN process started on that never-displayed desktop. Every later click on
# Chrome handed off to it and the window opened where nobody can see it. A browser that owns a window on the hidden
# desktop is closed (by PID, with its tree) so the next launch starts on the operator's desktop.
Add-Type @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class HiddenWins {
    delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern IntPtr OpenDesktop(string n, uint f, bool i, uint a);
    [DllImport("user32.dll")] static extern bool CloseDesktop(IntPtr h);
    [DllImport("user32.dll")] static extern bool EnumDesktopWindows(IntPtr d, EnumProc p, IntPtr l);
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    public static uint[] Pids(string desktop) {
        var set = new HashSet<uint>();
        IntPtr d = OpenDesktop(desktop, 0, false, 0x0040);  // DESKTOP_ENUMERATE
        if (d == IntPtr.Zero) return new uint[0];
        EnumDesktopWindows(d, (h, l) => { uint p; GetWindowThreadProcessId(h, out p); set.Add(p); return true; }, IntPtr.Zero);
        CloseDesktop(d);
        var a = new uint[set.Count]; set.CopyTo(a); return a;
    }
}
"@
$browsers = '^(chrome|brave|msedge)$'

# One guard at a time.
$others = Get-CimInstance Win32_Process | Where-Object { $_.CommandLine -match 'no_popups\.ps1' -and $_.ProcessId -ne $PID }
if ($others) { exit 0 }

while ($true) {
    foreach ($bp in [HiddenWins]::Pids('FightCampHidden')) {
        $proc = Get-Process -Id $bp
        if ($proc -and $proc.ProcessName -match $browsers) {
            taskkill /PID $bp /T /F | Out-Null
            Add-Content -Path $log -Value ("{0}  closed {1} pid={2} - its window was on the hidden desktop" -f (Get-Date -Format s), $proc.ProcessName, $bp)
        }
    }
    if (-not (Test-Path $flag)) {
        Get-Process | Where-Object { $_.ProcessName -match $names -and $_.StartTime -gt $since } | ForEach-Object {
            $title = $_.MainWindowTitle
            Stop-Process -Id $_.Id -Force
            Add-Content -Path $log -Value ("{0}  closed {1} pid={2} '{3}'" -f (Get-Date -Format s), $_.ProcessName, $_.Id, $title)
        }
    }
    Start-Sleep -Seconds $IntervalSeconds
}
