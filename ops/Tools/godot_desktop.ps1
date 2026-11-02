# godot_desktop.ps1 - run a WINDOWED Godot job on a separate, never-displayed Win32 desktop.
#
# Operator, 2026-10-04: "can you run the test in a virtual windows environment so i do not see the popups".
# godot_hidden.ps1 starts Godot on the operator's own desktop and moves its window off every monitor ~15 ms later,
# so a window can still flash. This launcher creates a second desktop object ("FightCampHidden") in the same window
# station and starts the job ON it (CreateProcess lpDesktop). Windows only ever shows the input desktop, so nothing
# the job opens - Godot's window, its console, a crash dialog - can reach a monitor. The GPU still renders (same
# session, same driver), so --write-movie and viewport captures work as before.
#
# Usage (all Godot args after the script path pass through unchanged; output goes to $env:FIGHTCAMP_DESKTOP_LOG,
# default godot_desktop.log in the current directory):
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_desktop.ps1 --path Godot --script tools/x.gd -- a=1
# Exit code is Godot's. The job runs at IDLE priority, like the agent launchers.
$GodotArgs = @($args)

$ErrorActionPreference = "Stop"
$godot = Join-Path $env:LOCALAPPDATA "Programs\Godot\Godot_v4.7.2-stable_win64_console.exe"
if ($env:FIGHTCAMP_GODOT_EXE) { $godot = $env:FIGHTCAMP_GODOT_EXE }
# S166 (operator 2026-10-05: "please no popups on my other monitor" - the window was a black console): on Windows 11
# a *_console.exe is handed to Windows Terminal, which opens on the operator's INPUT desktop whatever desktop or flags
# the job was given. Run the GUI sibling (Godot_v4.7.2-stable_win64.exe / FightCamp.exe); its output still reaches
# the redirect.
if ($godot -match '_console\.exe$') { $gui = $godot -replace '_console\.exe$', '.exe'; if (Test-Path $gui) { $godot = $gui } }
if (-not (Test-Path $godot)) { Write-Error "Godot not found at $godot"; exit 2 }
$Log = $env:FIGHTCAMP_DESKTOP_LOG
if (-not $Log) { $Log = Join-Path (Get-Location) "godot_desktop.log" }

Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class HiddenDesk {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct STARTUPINFO { public int cb; public string lpReserved; public string lpDesktop; public string lpTitle;
        public int dwX, dwY, dwXSize, dwYSize, dwXCountChars, dwYCountChars, dwFillAttribute, dwFlags;
        public short wShowWindow, cbReserved2; public IntPtr lpReserved2, hStdInput, hStdOutput, hStdError; }
    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION { public IntPtr hProcess, hThread; public int dwProcessId, dwThreadId; }
    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern IntPtr CreateDesktop(string name, IntPtr dev, IntPtr mode, uint flags, uint access, IntPtr sa);
    [DllImport("user32.dll", SetLastError = true)] public static extern bool CloseDesktop(IntPtr h);
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern bool CreateProcess(string app, string cmd, IntPtr pa, IntPtr ta, bool inherit, uint flags,
        IntPtr env, string cwd, ref STARTUPINFO si, out PROCESS_INFORMATION pi);
    [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr h, uint ms);
    [DllImport("kernel32.dll")] public static extern bool GetExitCodeProcess(IntPtr h, out uint code);
    [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
    // Launch `cmd` on `desktop` and wait. Returns the exit code, or -(Win32 error) when it could not start.
    public static int Run(string cmd, string cwd, string desktop) {
        STARTUPINFO si = new STARTUPINFO();
        si.cb = Marshal.SizeOf(typeof(STARTUPINFO));
        si.lpDesktop = desktop;
        PROCESS_INFORMATION pi;
        // IDLE_PRIORITY_CLASS 0x40 | CREATE_NO_WINDOW 0x08000000. S166: it was CREATE_NEW_CONSOLE 0x10, and Windows 11
        // hands a new console to Windows Terminal, which opened on the operator's monitor (not on this hidden desktop).
        if (!CreateProcess(null, cmd, IntPtr.Zero, IntPtr.Zero, false, 0x08000040, IntPtr.Zero, cwd, ref si, out pi))
            return -Marshal.GetLastWin32Error();
        Console.WriteLine("godot_desktop: pid " + pi.dwProcessId + " on " + desktop);
        WaitForSingleObject(pi.hProcess, 0xFFFFFFFF);
        uint code; GetExitCodeProcess(pi.hProcess, out code);
        CloseHandle(pi.hThread); CloseHandle(pi.hProcess);
        return (int)code;
    }
}
"@

$deskName = "FightCampHidden"
# GENERIC_ALL; opens the desktop if it already exists.
$desk = [HiddenDesk]::CreateDesktop($deskName, [IntPtr]::Zero, [IntPtr]::Zero, 0, 0x10000000, [IntPtr]::Zero)
if ($desk -eq [IntPtr]::Zero) { Write-Error ("CreateDesktop failed: " + [Runtime.InteropServices.Marshal]::GetLastWin32Error()); exit 2 }

function Quote([string]$a) { if ($a -match '[\s"]') { '"' + ($a -replace '"', '\"') + '"' } else { $a } }
$inner = (@((Quote $godot)) + ($GodotArgs | ForEach-Object { Quote $_ })) -join " "
# cmd does the redirection; its console is created on the hidden desktop too.
$cmdLine = (Quote $env:ComSpec) + ' /d /s /c "' + $inner + ' > ' + (Quote $Log) + ' 2>&1"'
$code = [HiddenDesk]::Run($cmdLine, (Get-Location).ProviderPath, "WinSta0\" + $deskName)
[void][HiddenDesk]::CloseDesktop($desk)
if ($code -lt 0) { Write-Error ("CreateProcess failed: Win32 error " + (-$code) + " cmd: " + $cmdLine); exit 2 }
Write-Output ("godot_desktop: exit " + $code + ", log " + $Log)
exit $code
