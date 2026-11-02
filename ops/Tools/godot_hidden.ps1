# godot_hidden.ps1 - run a WINDOWED Godot job without it popping up on the operator's screen.
#
# Operator, 2026-09-23: "can you make the windows that the agents open do not pop and run
# silently in the background". Render tools cannot run --headless (no GPU output), and Godot
# CLAMPS both `--position` and DisplayServer.window_set_position() back onto a visible monitor
# (measured: --position 20000,20000 landed at 1486,761; a script move to -32000 read back 0,0).
# So the hiding is done from OUTSIDE: start Godot, wait for its window, then Win32 SetWindowPos
# it to -32000,-32000 (off every monitor, NOT minimized - a minimized Godot stops drawing, so
# captures would come out empty), no activation, and drop its taskbar button.
#
# S133 (operator 2026-09-30, during two S133 recordings: "can you make the debug popup stop"):
# the window titled "... (DEBUG)" still reached the screen. Two holes: (1) the watch loop ran a
# CIM process query every 50 ms pass, so the first hide came late; (2) each window was hidden
# ONCE, and Godot moves its own window afterwards (movie mode resizes 1280x720 -> 1920x1080 and
# re-centres it), which put it back on the monitor for the rest of the job. Now the loop checks
# every 15 ms against a cached pid list and re-hides ANY visible window of the job whose left
# edge is back on a monitor. FIGHTCAMP_HIDDEN_TRACE=1 prints each hide (ms since start, rect).
#
# Usage (all Godot args after the script path are passed through unchanged):
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/x.gd -- arg=1
# Exit code is Godot's. Output (stdout+stderr) is streamed to this console.

$ErrorActionPreference = "Stop"
$godot = Join-Path $env:LOCALAPPDATA "Programs\Godot\Godot_v4.7.2-stable_win64_console.exe"
# S74: FIGHTCAMP_GODOT_EXE runs an EXPORTED build instead (Builds\FightCamp_Godot\FightCamp_console.exe).
if ($env:FIGHTCAMP_GODOT_EXE) { $godot = $env:FIGHTCAMP_GODOT_EXE }
# S166 (operator 2026-10-05: "please no popups on my other monitor" - the window was a black console): on Windows 11
# a *_console.exe is handed to Windows Terminal, which opens on the operator's INPUT desktop whatever desktop or flags
# the job was given. Run the GUI sibling (Godot_v4.7.2-stable_win64.exe / FightCamp.exe); its output still reaches
# the redirect.
if ($godot -match '_console\.exe$') { $gui = $godot -replace '_console\.exe$', '.exe'; if (Test-Path $gui) { $godot = $gui } }
if (-not (Test-Path $godot)) { Write-Error "Godot not found at $godot"; exit 2 }

Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
public static class HideWin {
    [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L, T, R, B; }
    [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr after, int x, int y, int cx, int cy, uint flags);
    [DllImport("user32.dll")] public static extern int GetWindowLong(IntPtr h, int idx);
    [DllImport("user32.dll")] public static extern int SetWindowLong(IntPtr h, int idx, int val);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool AttachThreadInput(uint a, uint b, bool attach);
    [DllImport("kernel32.dll")] public static extern uint GetCurrentThreadId();
    public static IntPtr Before = IntPtr.Zero;
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    public static void Hide(IntPtr h) {
        const int GWL_EXSTYLE = -20; const int WS_EX_TOOLWINDOW = 0x80; const int WS_EX_APPWINDOW = 0x40000;
        int ex = GetWindowLong(h, GWL_EXSTYLE);
        SetWindowLong(h, GWL_EXSTYLE, (ex | WS_EX_TOOLWINDOW) & ~WS_EX_APPWINDOW);
        // SWP_NOSIZE 0x1 | SWP_NOZORDER 0x4 | SWP_NOACTIVATE 0x10 | SWP_FRAMECHANGED 0x20
        SetWindowPos(h, IntPtr.Zero, -32000, -32000, 0, 0, 0x1 | 0x4 | 0x10 | 0x20);
    }
    // Every visible top-level window of these pids whose left edge is back on a monitor is
    // hidden again. Returns one line per window hidden, "" when nothing was on screen.
    public static string HideAll(uint[] pids) {
        StringBuilder log = new StringBuilder();
        EnumWindows((h, l) => {
            uint p; GetWindowThreadProcessId(h, out p);
            if (Array.IndexOf(pids, p) >= 0 && IsWindowVisible(h)) {
                RECT r; GetWindowRect(h, out r);
                if (r.L > -30000) {
                    Hide(h);
                    // A shown Godot window takes the keyboard: whatever the operator was typing
                    // into would go to a window nobody can see. Hand focus back to where it was.
                    bool stole = GetForegroundWindow() == h;
                    bool back = false;
                    if (stole && Before != IntPtr.Zero && Before != h) {
                        uint dummy; uint fg = GetWindowThreadProcessId(h, out dummy); uint me = GetCurrentThreadId();
                        AttachThreadInput(me, fg, true);
                        back = SetForegroundWindow(Before);
                        AttachThreadInput(me, fg, false);
                    }
                    log.AppendLine(String.Format("hwnd {0} pid {1} rect {2},{3} {4}x{5} took_focus {6} focus_returned {7}", h, p, r.L, r.T, r.R - r.L, r.B - r.T, stole, back));
                }
            }
            return true;
        }, IntPtr.Zero);
        return log.ToString();
    }
}
"@

# A console exe (FIGHTCAMP_GODOT_EXE without a GUI sibling) spawns the real windowed Godot as a child; watch both.
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $godot
# S116 (operator: "i dont want to hear sounds"): a hidden job is SILENT too - Godot's Dummy audio
# driver, unless the caller passes its own --audio-driver or sets FIGHTCAMP_GODOT_AUDIO=on.
$godotArgs = @($args)
if (-not ($godotArgs -contains '--audio-driver') -and $env:FIGHTCAMP_GODOT_AUDIO -ne 'on') {
    $godotArgs = @('--audio-driver', 'Dummy') + $godotArgs
}
# S161 (operator 2026-10-04: "can you run the test in a virtual windows environment so i do not see the popups"):
# moving the window off-screen ~15 ms after it appears can still flash it. By default the job now runs on a second,
# never-displayed Win32 desktop (Tools\godot_desktop.ps1) - nothing it opens can reach a monitor. Output is printed at
# exit, as below. FIGHTCAMP_VISIBLE_DESKTOP=1 keeps the old off-screen path.
if ($env:FIGHTCAMP_VISIBLE_DESKTOP -ne '1') {
    $deskLog = [System.IO.Path]::GetTempFileName()
    $env:FIGHTCAMP_DESKTOP_LOG = $deskLog
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "godot_desktop.ps1") @godotArgs | Out-Null
    $deskCode = $LASTEXITCODE
    if (Test-Path $deskLog) { Get-Content -Raw $deskLog | Write-Output; Remove-Item $deskLog -ErrorAction SilentlyContinue }
    exit $deskCode
}
$psi.Arguments = ($godotArgs | ForEach-Object { if ($_ -match '\s') { '"' + $_ + '"' } else { $_ } }) -join ' '
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
# S62 (2026-09-24): Godot's console output was LOST when this launcher was redirected to a file
# (0 lines captured from a 10-minute probe, twice). Capture both streams and print them at exit.
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
[HideWin]::Before = [HideWin]::GetForegroundWindow()
$proc = [System.Diagnostics.Process]::Start($psi)
# S143 (operator: "control the pc load , cpu usage is too much"): Godot inherited its caller's priority -
# AboveNormal from the Claude process - so every hidden render competed with the operator's desktop.
# IDLE like every agent launcher (operator 2026-09-25); movie mode runs on a fixed clock, so the output
# is the same frames, only later. The child the console shim spawns is set below as soon as it appears.
try { $proc.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle } catch {}
$idled = @{}
$stdoutTask = $proc.StandardOutput.ReadToEndAsync()
$stderrTask = $proc.StandardError.ReadToEndAsync()

$trace = ($env:FIGHTCAMP_HIDDEN_TRACE -eq '1')
$clock = [System.Diagnostics.Stopwatch]::StartNew()
$pids = [uint32[]]@($proc.Id)
$nextPidScan = 0
$hides = 0
while (-not $proc.HasExited) {
    # The CIM query is the slow part (tens of ms); the child's pid only needs finding once it exists.
    if ($clock.ElapsedMilliseconds -ge $nextPidScan) {
        $kids = @(Get-CimInstance Win32_Process -Filter "ParentProcessId=$($proc.Id)" -ErrorAction SilentlyContinue | ForEach-Object { [uint32]$_.ProcessId })
        $pids = [uint32[]](@([uint32]$proc.Id) + $kids)
        foreach ($k in $kids) {
            if (-not $idled.ContainsKey($k)) {
                try { (Get-Process -Id $k -ErrorAction Stop).PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle } catch {}
                $idled[$k] = $true
            }
        }
        $nextPidScan = $clock.ElapsedMilliseconds + $(if ($kids.Count -gt 0) { 2000 } else { 100 })
    }
    $done = [HideWin]::HideAll($pids)
    if ($done -ne "") {
        $hides += ($done.Trim() -split "`n").Count
        if ($trace) { [Console]::Error.WriteLine(("HIDDEN_TRACE {0} ms: {1}" -f $clock.ElapsedMilliseconds, $done.Trim())) }
    }
    Start-Sleep -Milliseconds 15
}
if ($trace) { [Console]::Error.WriteLine(("HIDDEN_TRACE hides={0} over {1} ms" -f $hides, $clock.ElapsedMilliseconds)) }
$proc.WaitForExit()
Write-Output $stdoutTask.Result
Write-Output $stderrTask.Result
exit $proc.ExitCode
