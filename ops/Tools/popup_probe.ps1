# popup_probe.ps1 - run a command and report every window it put on the operator's (input) desktop.
#
# S166 (operator 2026-10-05: "please no popups on my other monitor", "i keep seeing popups stop it"; the window was a
# black console): the launchers are proven silent by this probe, never by reading their flags. It snapshots the
# visible top-level windows and the console-host processes (WindowsTerminal, OpenConsole) before the command, polls
# every 10 ms while it runs, and lists every NEW visible window (any position - one parked off-screen still counts)
# and every NEW console-host process. Exit 0 = silent, 1 = something appeared, 2 = bad usage.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\popup_probe.ps1 -Command "python Godot/tools/check_scripts.py x.gd"
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\popup_probe.ps1 -Control
#     (-Control opens a WinForms window at -32000,-32000 for 1 s: the probe must read it, exit 1; nothing reaches a monitor)
param([string]$Command = "", [switch]$Control)

$ErrorActionPreference = "Stop"
Add-Type @"
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class PopProbe {
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
    public static Dictionary<long, string> Visible() {
        var d = new Dictionary<long, string>();
        EnumWindows((h, l) => {
            if (IsWindowVisible(h)) {
                uint p; GetWindowThreadProcessId(h, out p);
                var sb = new StringBuilder(256); GetWindowText(h, sb, 256);
                d[h.ToInt64()] = "pid " + p + " '" + sb.ToString() + "'";
            }
            return true;
        }, IntPtr.Zero);
        return d;
    }
}
"@

function HostPids { @(Get-Process -Name WindowsTerminal, OpenConsole -ErrorAction SilentlyContinue | ForEach-Object { $_.Id }) }

if (-not $Command -and -not $Control) { Write-Output "usage: -Command '<cmd>' or -Control"; exit 2 }
$before = [PopProbe]::Visible()
$hostsBefore = HostPids
$seen = @{}
$newHosts = @{}

if ($Control) {
    $Command = 'powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.Form; $f.StartPosition = ''Manual''; $f.Location = New-Object System.Drawing.Point(-32000,-32000); $f.ShowInTaskbar = $false; $f.Text = ''popup_probe control''; $f.Show(); Start-Sleep -Milliseconds 1000; $f.Close()"'
}
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $env:ComSpec
$psi.Arguments = '/d /s /c "' + $Command + '"'
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.WorkingDirectory = (Get-Location).ProviderPath
$clock = [System.Diagnostics.Stopwatch]::StartNew()
$proc = [System.Diagnostics.Process]::Start($psi)
$outTask = $proc.StandardOutput.ReadToEndAsync()
$errTask = $proc.StandardError.ReadToEndAsync()
$nextHostScan = 0
do {
    $now = [PopProbe]::Visible()
    foreach ($k in $now.Keys) {
        if (-not $before.ContainsKey($k) -and -not $seen.ContainsKey($k)) { $seen[$k] = ("{0} ms hwnd {1} {2}" -f $clock.ElapsedMilliseconds, $k, $now[$k]) }
    }
    if ($clock.ElapsedMilliseconds -ge $nextHostScan) {
        foreach ($h in HostPids) { if ($hostsBefore -notcontains $h -and -not $newHosts.ContainsKey($h)) { $newHosts[$h] = ("{0} ms console host pid {1}" -f $clock.ElapsedMilliseconds, $h) } }
        $nextHostScan = $clock.ElapsedMilliseconds + 250
    }
    Start-Sleep -Milliseconds 10
} while (-not $proc.HasExited)
$proc.WaitForExit()
# A console host started late (after the job's last poll) still counts.
foreach ($h in HostPids) { if ($hostsBefore -notcontains $h -and -not $newHosts.ContainsKey($h)) { $newHosts[$h] = ("exit console host pid {0}" -f $h) } }

$tail = (($outTask.Result + $errTask.Result) -split "`n" | Select-Object -Last 4) -join "`n"
Write-Output ("POPUP_PROBE command rc={0} in {1} ms; last output:`n{2}" -f $proc.ExitCode, $clock.ElapsedMilliseconds, $tail.Trim())
$n = $seen.Count + $newHosts.Count
foreach ($v in $seen.Values) { Write-Output ("  NEW WINDOW  " + $v) }
foreach ($v in $newHosts.Values) { Write-Output ("  NEW HOST    " + $v) }
# A window that belongs to an app the operator opened during the run is noise only if its pid is not ours; the list
# names pids so the reader can tell. The verdict counts everything.
if ($n -eq 0) { Write-Output "POPUP_PROBE SILENT (0 new windows, 0 new console hosts)"; exit 0 }
Write-Output ("POPUP_PROBE SEEN {0} (windows {1}, console hosts {2})" -f $n, $seen.Count, $newHosts.Count)
exit 1
