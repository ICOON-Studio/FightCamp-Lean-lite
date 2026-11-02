---
name: project-d-drive-failing
description: "S138 2026-10-01 - D: HDD (WD15EARS) is failing and causes the PC freezes; worktrees moved to E:, backup done, operator buying a replacement"
metadata:
  node_type: memory
  type: project
  originSessionId: 2efd35e0-73cc-469f-a531-288cbc1096cc
  modified: 2026-10-01T19:00:24.362Z
---

D: = WD15EARS 1.5 TB, 51,321 power-on hours, 758 read errors, max latency 10.3 s; Windows logged storahci event 129
("Reset to device") 11 times in 2 weeks - each one freezes the whole PC (the operator's "freezing for 20 minutes").
Resets cluster under heavy D: I/O: the 05:00 nightly suite, fresh worktrees (15,500 files / 2.4 GB each), asset imports.

**Why:** operator asked 2026-10-01 why the PC froze; the event log + reliability counters answered it.

**How to apply:** operator rulings S138: new agent worktrees go to `E:\FightCamp\wt` (CLAUDE.md s4 updated); D: is
read-only archive, nothing new on it; irreplaceable folders backed up to `E:\FightCamp_backup_D` (3,199 files, 9 GB,
0 errors). Operator will buy a replacement drive - when it is in, move D:'s contents onto it. Check
`Get-WinEvent ... storahci 129` when the PC freezes again. Related: [[project_pc_thermal_limit]].

**S139 2026-10-02 01:04, freeze #N, cause measured:** the Windows PAGEFILE is on D: (`D:\pagefile.sys`, 45 GB allocated,
7.7-8 GB in use). The MetaHuman pilot's UE commandlet (5.7 GB) + 13 ShaderCompileWorkers (3.3 GB) on top of 4 shell agents
pushed RAM to 75% and paged onto the failing HDD: D: 2118% busy, queue 21 -> the PC froze. Killing UE dropped RAM to 59%.
**How to apply:** never run an Unreal build/shader compile while shell agents run (run it alone, cap workers); the real
fix is the operator moving the pagefile to C: (NVMe, 86 GB free) - a system setting only he changes (System > Advanced >
Performance > Virtual memory: C: system managed, D: no paging file, reboot). Also grok.exe lives on D:
(D:\FightCamp\tools\grok) - move it to E: when convenient. Never run git/status on D: worktrees.

S139 (2026-10-02, after another freeze; operator: "make sure there is nothing on d that we use", "move blender, clis to
c and everything that is missing to e"): THE PAGEFILE (45 GB, Windows-managed) WAS ON D: - 7.7 GB paged to the dying
disk whenever RAM filled = the freezes. Pagefile moves are a system setting: the OPERATOR moves it (steps given in chat).
Done by Claude: Blender 5.2.1 -> C:\Tools\Blender\blender-5.2.1-windows-x64; Grok -> C:\Tools\grok\bin; Kimi ->
C:\Tools\kimi-code (user PATH repointed); MPFB assets -> E:\AI\mpfb_assets; uv-python/cache/downloads -> E:\FightCamp;
recorder videos + fal outputs -> E:; agent_comms start skips the 25 old D: worktrees (commit 588a8f5f). Still only on D:
(unused): D:\FightCamp\wt (83 GB old worktrees, branches on origin), worktree_leftovers (20 GB), tmp, his Epic games.
SMART 10-02: 758 uncorrected read errors, 51,325 power-on hours, 8 storahci 129 resets in 2 days - NOT repairable.


S190 2026-10-09: operator "remove the drive so windows cannot see it" -> disk 1 WDC WD15EARS (serial WD-WMAVU1360068) set OFFLINE (Set-Disk -Number 1 -IsOffline $true; undo with $false). Pagefile already on C:. D:/FightCamp/videos and the 25 registered D: worktrees are unreachable - never run `git worktree prune` expecting them; backup of irreplaceable folders: E:/FightCamp_backup_D.

S190: operator "terminate amd app" + "remove it from startup": AMD Software processes stopped by PID; scheduled tasks StartCN, StartCNBM, StartDVR DISABLED (undo: Enable-ScheduledTask <name>); ReLive ShowIndicator=0. Kept: AMDRyzenMasterSDKTask, AMDNoiseSuppression, AUEP, driver services.
