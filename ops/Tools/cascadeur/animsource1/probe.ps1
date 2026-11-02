param(
    [string]$Moves = 'inside_uppercut,jab,cross,lead_hook',
    [string]$Out = 'E:/FightCamp/tmp/animsource1b',
    [string]$Clips = 'res://assets/anim/metahuman',
    [switch]$Sheets,
    [switch]$Imported
)
$ErrorActionPreference = 'Stop'
$repo = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
Set-Location -LiteralPath $repo
python Godot/tools/check_scripts.py Godot/tools/move_shape_probe.gd
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
do {
    $watch = & powershell -NoProfile -ExecutionPolicy Bypass -File Tools/pc_watchdog.ps1 -Once
    $watch | Write-Output
    $red = "$watch" -match ' RED |RED   '
    if ($red) { Start-Sleep -Seconds 15 }
} while ($red)
$env:FIGHTCAMP_GODOT_EXE = 'C:/Users/user/AppData/Local/Programs/Godot/Godot_v4.7.2-stable_win64.exe'
$engineArgs = @('--path','Godot','--script','tools/move_shape_probe.gd','--',"moves=$Moves","out=$Out","clips=$Clips")
if ($Sheets) { $engineArgs += 'sheets=1' } else { $engineArgs = @('--headless') + $engineArgs }
if ($Imported) { $engineArgs += 'imported=1' }
$lines = & powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 @engineArgs
$code = $LASTEXITCODE
$lines | Write-Output
$lines | Set-Content -LiteralPath (Join-Path $PSScriptRoot '_last_probe.log')
if ("$lines" -match 'SCRIPT ERROR:|ERROR:') { exit 2 }
exit $code
