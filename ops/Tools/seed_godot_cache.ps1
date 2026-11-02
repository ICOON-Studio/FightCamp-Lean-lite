# seed_godot_cache.ps1 - copy the main checkout's Godot import cache (Godot/.godot, ~4.4 GB) into an agent worktree (S206).
#
# WHY (operator S206, "stay on the plan, do the cache fix and see how it goes"): a fresh worktree has no .godot folder, so the
# agent's first Godot command runs a FULL editor import - S206 measured it as the heaviest process on the PC while the CPU hit
# 87 C / 100% (operator limit 84 C). Copying the cache is disk work, not CPU work; Godot then only re-imports what changed.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\<NAME>
#
# Run it BEFORE launching an agent in a new worktree (and before any Godot command there). robocopy runs at IDLE priority with
# 2 threads; files already present and identical are skipped, so a re-run is cheap. The main checkout's cache is only READ.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Worktree,
    [string]$Source = ""
)
# PS 5.1 leaves $PSScriptRoot empty inside param defaults - resolve the main checkout here.
if (-not $Source) { $Source = Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "Godot\.godot" }
$dest = Join-Path $Worktree "Godot\.godot"
if (-not (Test-Path (Join-Path $Worktree "Godot\project.godot"))) { Write-Output "SEED FAIL: no Godot project in $Worktree"; exit 2 }
if (-not (Test-Path $Source)) { Write-Output "SEED FAIL: no cache at $Source"; exit 2 }
$t0 = Get-Date
# S264 operator: "i do not want to hear the sounds from playtesting" - a game the agent's editor starts (playtest, run_scene)
# is a new process that ignores the editor's --audio-driver Dummy. override.cfg (never committed) forces Dummy for every run here.
$ovr = Join-Path $Worktree "Godot\override.cfg"
if (-not (Test-Path $ovr)) {
    [IO.File]::WriteAllText($ovr, "; S264 operator: no playtest sounds - every run from this worktree uses the Dummy audio driver. Never commit.`n[audio]`n`ndriver/driver=`"Dummy`"`n")
}
# /E all subfolders, /MT:2 two threads, /R:1 /W:1 no long retries, /XD shader_cache (rebuilt per GPU anyway), quiet logs.
$p = Start-Process -FilePath robocopy.exe -ArgumentList @("`"$Source`"", "`"$dest`"", "/E", "/MT:2", "/R:1", "/W:1", "/XD", "shader_cache", "/NFL", "/NDL", "/NJH", "/NJS", "/NP") -WindowStyle Hidden -PassThru
try { $p.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle } catch {}
$p.WaitForExit()
# robocopy: 0-7 = success (files copied / skipped / extra), >= 8 = failure.
$rc = $p.ExitCode
$gb = [math]::Round(((Get-ChildItem $dest -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1GB), 2)
$secs = [int]((Get-Date) - $t0).TotalSeconds
if ($rc -ge 8) { Write-Output "SEED FAIL robocopy rc=$rc ($gb GB in $dest, $secs s)"; exit 1 }
Write-Output "SEED OK $gb GB -> $dest in $secs s (robocopy rc=$rc)"
exit 0
