# proc_pause.ps1 - suspend or resume one process by PID (S217: on a RED watchdog, pause an agent's Godot job instead of
# killing it; resume when the watchdog is GREEN/AMBER). Uses ntdll NtSuspendProcess / NtResumeProcess.
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\proc_pause.ps1 -Id <pid> -Action suspend|resume
param([Parameter(Mandatory)][int]$Id, [ValidateSet('suspend','resume')][string]$Action = 'suspend')
Add-Type -Namespace FC -Name Nt -MemberDefinition @'
[DllImport("ntdll.dll")] public static extern int NtSuspendProcess(IntPtr h);
[DllImport("ntdll.dll")] public static extern int NtResumeProcess(IntPtr h);
'@
$p = Get-Process -Id $Id -ErrorAction Stop
$rc = if ($Action -eq 'suspend') { [FC.Nt]::NtSuspendProcess($p.Handle) } else { [FC.Nt]::NtResumeProcess($p.Handle) }
"$Action pid=$Id ($($p.ProcessName)) status=$rc"
