# Start Cascadeur on a desktop that is never switched onto a monitor.
# Keep the desktop handle alive for the entire application lifetime.
param([string]$CodeFile)
$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class CascadeurDesk {
 [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
 public struct SI { public int cb; public string reserved, desktop, title;
 public int x,y,xs,ys,xc,yc,fill,flags; public short show,cb2;
 public IntPtr reserved2,input,output,error; }
 [StructLayout(LayoutKind.Sequential)]
 public struct PI { public IntPtr process,thread; public int pid,tid; }
 [DllImport("user32.dll",CharSet=CharSet.Unicode,SetLastError=true)]
 public static extern IntPtr CreateDesktop(string n,IntPtr d,IntPtr m,uint f,uint a,IntPtr s);
 [DllImport("user32.dll")] public static extern bool CloseDesktop(IntPtr h);
 [DllImport("kernel32.dll",CharSet=CharSet.Unicode,SetLastError=true)]
 public static extern bool CreateProcess(string app,string cmd,IntPtr p,IntPtr t,bool inherit,uint flags,IntPtr env,string cwd,ref SI si,out PI pi);
 [DllImport("kernel32.dll")] public static extern uint WaitForSingleObject(IntPtr h,uint ms);
 [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
}
'@
$desk = [CascadeurDesk]::CreateDesktop('FightCampCascadeur',[IntPtr]::Zero,[IntPtr]::Zero,0,0x10000000,[IntPtr]::Zero)
if ($desk -eq [IntPtr]::Zero) { throw "CreateDesktop failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())" }
$si = New-Object CascadeurDesk+SI
$si.cb = [Runtime.InteropServices.Marshal]::SizeOf($si)
$si.desktop = 'WinSta0\FightCampCascadeur'
$pi = New-Object CascadeurDesk+PI
$exe = 'C:\Program Files\Cascadeur\cascadeur.exe'
$cmd = '"' + $exe + '"'
if ($CodeFile) {
 $code = "exec(compile(open(r'$CodeFile', encoding='utf-8').read(), r'$CodeFile', 'exec'))"
 $cmd += ' --run-python-code "' + $code + '"'
}
try {
 if (-not [CascadeurDesk]::CreateProcess($exe,$cmd,[IntPtr]::Zero,[IntPtr]::Zero,$false,0x08000040,[IntPtr]::Zero,(Get-Location).ProviderPath,[ref]$si,[ref]$pi)) {
  throw "CreateProcess failed: $([Runtime.InteropServices.Marshal]::GetLastWin32Error())"
 }
 Write-Output "Cascadeur pid=$($pi.pid) desktop=$($si.desktop)"
 [void][CascadeurDesk]::WaitForSingleObject($pi.process,[uint32]::MaxValue)
} finally {
 if ($pi.thread -ne [IntPtr]::Zero) { [void][CascadeurDesk]::CloseHandle($pi.thread) }
 if ($pi.process -ne [IntPtr]::Zero) { [void][CascadeurDesk]::CloseHandle($pi.process) }
 [void][CascadeurDesk]::CloseDesktop($desk)
}
