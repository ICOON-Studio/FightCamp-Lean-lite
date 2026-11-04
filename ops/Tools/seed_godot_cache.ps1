# seed_godot_cache.ps1 - seed an agent worktree with the main checkout's Godot import cache (.godot, ~0.5 GB in Lean) (S206).
#
# WHY (operator S206, "stay on the plan, do the cache fix and see how it goes"): a fresh worktree has no .godot folder, so the
# agent's first Godot command runs a FULL editor import - S206 measured it as the heaviest process on the PC while the CPU hit
# 87 C / 100% (operator limit 84 C). Copying the cache is disk work, not CPU work; Godot then only re-imports what changed.
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\<NAME>
#
# Run it BEFORE launching an agent in a new worktree (and before any Godot command there). robocopy runs at IDLE priority with
# 2 threads; files already present and identical are skipped, so a re-run is cheap. The main checkout's cache is only READ.
#
# S380 (E: 91% full, a DRAM-less SATA SSD that stalls on big writes): .godot\imported (2,700 files, ~0.5 GB) is HARDLINKED
# from the main checkout instead of copied - 0 bytes written. Safe because Godot saves every import as <file>.tmp and then
# renames it over the old name (filesystem/on_save/safe_save_on_backup_then_rename, default on): a reimport in the worktree
# replaces ITS link and never writes into main's file. Probed S380: a changed asset reimported in a linked worktree left
# main's .ctex/.md5 byte-identical. Only the small rest (editor\, uid_cache.bin, class cache) is copied. -Copy = the old full copy.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Worktree,
    [string]$Source = "",
    [switch]$Copy
)
# PS 5.1 leaves $PSScriptRoot empty inside param defaults - resolve the main checkout here.
# S368: Lean keeps project.godot at the repo root (script in ops\Tools, so the main checkout is two folders up); the old
# repo's Godot\ subfolder is still accepted for any worktree that has one.
$main = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path))
$sub = if (Test-Path (Join-Path $Worktree "project.godot")) { "" } elseif (Test-Path (Join-Path $Worktree "Godot\project.godot")) { "Godot" } else { $null }
if ($null -eq $sub) { Write-Output "SEED FAIL: no Godot project in $Worktree"; exit 2 }
$proj = if ($sub) { Join-Path $Worktree $sub } else { $Worktree }
if (-not $Source) { $Source = Join-Path $main ".godot" }
$dest = Join-Path $proj ".godot"
if (-not (Test-Path $Source)) { Write-Output "SEED FAIL: no cache at $Source"; exit 2 }
$t0 = Get-Date
# S264 operator: "i do not want to hear the sounds from playtesting" - a game the agent's editor starts (playtest, run_scene)
# is a new process that ignores the editor's --audio-driver Dummy. override.cfg (never committed) forces Dummy for every run here.
$ovr = Join-Path $proj "override.cfg"
if (-not (Test-Path $ovr)) {
    [IO.File]::WriteAllText($ovr, "; S264 operator: no playtest sounds - every run from this worktree uses the Dummy audio driver. Never commit.`n[audio]`n`ndriver/driver=`"Dummy`"`n")
}
$linked = 0; $copied = 0
if (-not $Copy) {
    Add-Type -Namespace FightCamp -Name HardLink -MemberDefinition '[DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)] public static extern bool CreateHardLink(string lpFileName, string lpExistingFileName, IntPtr lpSecurityAttributes);'
    $srcImp = Join-Path $Source "imported"
    $dstImp = Join-Path $dest "imported"
    if (Test-Path $srcImp) {
        New-Item -ItemType Directory -Force -Path $dstImp | Out-Null
        foreach ($f in Get-ChildItem -LiteralPath $srcImp -File -Recurse -ErrorAction SilentlyContinue) {
            if ($f.Extension -eq ".tmp") { continue }   # a half-written save in main, never a cache file
            $to = Join-Path $dstImp $f.FullName.Substring($srcImp.Length).TrimStart("\")
            if (Test-Path -LiteralPath $to) { continue }  # a re-run, or a file the worktree already reimported
            $dir = Split-Path -Parent $to
            if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
            if ([FightCamp.HardLink]::CreateHardLink($to, $f.FullName, [IntPtr]::Zero)) { $linked++ }
            else { Copy-Item -LiteralPath $f.FullName -Destination $to -ErrorAction SilentlyContinue; $copied++ }  # another volume
        }
    }
}
# /E all subfolders, /MT:2 two threads, /R:1 /W:1 no long retries, /XD shader_cache (rebuilt per GPU anyway) and imported (linked
# above, unless -Copy), quiet logs.
$xd = @("shader_cache"); if (-not $Copy) { $xd += "imported" }
$p = Start-Process -FilePath robocopy.exe -ArgumentList (@("`"$Source`"", "`"$dest`"", "/E", "/MT:2", "/R:1", "/W:1", "/XD") + $xd + @("/NFL", "/NDL", "/NJH", "/NJS", "/NP")) -WindowStyle Hidden -PassThru
try { $p.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::Idle } catch {}
$p.WaitForExit()
# robocopy: 0-7 = success (files copied / skipped / extra), >= 8 = failure.
$rc = $p.ExitCode
$gb = [math]::Round(((Get-ChildItem $dest -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1GB), 2)
$secs = [int]((Get-Date) - $t0).TotalSeconds
if ($rc -ge 8) { Write-Output "SEED FAIL robocopy rc=$rc ($gb GB in $dest, $secs s)"; exit 1 }
$how = if ($Copy) { "copied" } else { "$linked hardlinked + $copied copied in imported\, the rest copied" }
Write-Output "SEED OK $gb GB -> $dest in $secs s ($how; robocopy rc=$rc)"
exit 0
